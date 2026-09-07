function cleanedMatrix = cleanData(A)
    %removes any rows containing NAN values from input matrix
    cleanedMatrix = rmmissing(A)
end