function numstr = num2strwithzeros(integer)
    numstr = num2str(integer);
    if integer<10
        numstr=strcat('0',numstr);
    end
end
