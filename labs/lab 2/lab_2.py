"""
DC Motor Control and Data Acquisition Script
Communicates with MATLAB over a virtual serial port to run hardware experiments
or numerical simulations of an RP2040-driven motor system.
"""

import time
import math
import gc
import ttyacm
from sbc import SBC

# Instantiate the RP2040 WRC SBC
lab = SBC()

# Code parameters
updateRate = 100  # Sampling rate in Hz
per = 1 / updateRate  # Sampling period in seconds

def main():
    """Main function handling communication, experiment execution, and data transmission."""
    tty = ttyacm.open(1)  # Open virtual serial port link
    
    while True:
        gc.collect()
        print("Waiting for data from MATLAB")
        
        # Read parameters from MATLAB
        in_msg = tty.readline()
        paras = in_msg.strip()
        exp = int(paras[0])   # 1 = experiment, 0 = simulation
        ctrl = int(paras[1])  # 0 = open-loop, 1 = P, 2 = PI
        
        # Read target motor voltage
        in_msg2 = tty.readline()
        if ctrl == 0:
            motorVolt = float(in_msg2)

        print(f"Starting trial | Mode: {'Experiment' if exp == 1 else 'Simulation'} | Ctrl: {ctrl}")
        
        # Initialize timing
        t_start = time.ticks_ms()
        t_elapsed = 0.0
        
        # Initialize data logging lists
        t_list = []
        pos_list = []
        spd_list = []
        inpt_list = []
        
        # ==========================================
        # SECTION: INITIALIZE AGING VARIABLES
        # ==========================================
        if exp == 1:
            # Physical Hardware: Read the starting position of the encoder 
            # to prime the backward-difference calculation for velocity.
            pos_prev_counts = lab._enc_device1.read_counter()
            pos_prev =  pos_prev_counts*(2*math.pi/4096) # MUST ADD CODE
            speed = 0.0
        else:
            # Simulation: Initialize the prior integration states 
            # for the numerical differential equation solver.
            pos_prev = 0.0   # Initial simulated position (rad)
            speed = 0.0      # Initial simulated speed (rad/s)
            
        # ==========================================
        
        gc.collect()
        
        # Main Execution Loop (Runs for 2.0 seconds)
        while t_elapsed < 2.0:
            # Update time elapsed
            t_elapsed = (time.ticks_ms() - t_start) * 1e-3
            
            # ==========================================
            # SECTION: UPDATE SPEED AND POSITION DATA
            # ==========================================
            if exp == 1:
                # 1. Read current raw hardware encoder counts
                count = lab._enc_device1.read_counter() # MUST ADD CODE
                
                # 2. Convert raw discrete counts to continuous radians
                pos = count*(2*math.pi/4096) # MUST ADD CODE
                
                # 3. Estimate angular velocity using a backward-difference approximation:
                speed = (pos - pos_prev)/(per) # MUST ADD CODE
                
                # 4. Age the position variable: Store the current position 
                #    so it becomes the 'previous' position for the next iteration
                pos_prev = pos
            else:
                # 1. Update simulation states using numerical Euler integration
                #    TODO: Insert your DC motor state-space or transfer function model parameters here
                
                # 2. Integrate speed to find the new position
                
                
                # 3. Age the simulated position variable for the next loop step
                pos_prev = pos
                
            # ==========================================
            
            # Determine control voltage
            if ctrl == 0:
                outputVoltage = motorVolt
            else:
                outputVoltage = 0.0
                # TODO: Implement P/PI control tracking loops here
            
            # Enforce voltage saturation safety limits [-6.0V, 6.0V]
            outputVoltage = max(-6.0, min(outputVoltage, 6.0))
            
            # Actuate hardware if in experiment mode
            if exp == 1:
                lab._digipot_device.set_volt(outputVoltage)

            # Log data for MATLAB
            t_list.append(t_elapsed)
            pos_list.append(pos)
            spd_list.append(speed)
            inpt_list.append(outputVoltage)
            
            # Maintain sampling rate
            time.sleep(per)
            
        # Clean up after trial loop
        print("Finished trial execution")
        if exp == 1:
            lab._digipot_device.set_pot(0)  # Safe shutdown of motor

        # Transmit data back to MATLAB
        print("Sending trial data back to MATLAB...")
        for i in range(len(t_list)):
            out_msg = f"{t_list[i]},{pos_list[i]},{spd_list[i]},{inpt_list[i]};..."
            tty.print(out_msg)
            print(out_msg)  # Print to REPL for local debugging
            
        print("Finished sending trial data\n")

if __name__ == "__main__":
    main()