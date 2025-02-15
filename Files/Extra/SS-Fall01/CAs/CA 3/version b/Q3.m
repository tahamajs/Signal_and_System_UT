clc;
clear;
close all;

%3-1
charactersCount=32;
characters=['a':'z' ' ' '.' ',' '!' ';' '"'];
Mapset=cell(2, charactersCount);
for i=0:charactersCount-1
    Mapset{1, i+1}=characters(i+1);
    Mapset{2, i+1}=dec2bin(i, 5);
end

%3-2...3-8
bitRate=1;
noisePower=0;
message='signal';
test=false;

if ~test
    [codedMessage, divisibleByBitRate, messageLength]=coding_amp(message, bitRate, Mapset, noisePower, test);
    decodedMessage = decoding_amp(codedMessage, bitRate, Mapset, divisibleByBitRate, messageLength, noisePower);
    fprintf('decoded message is:\n')
    fprintf('%s', decodedMessage{:});
    fprintf('\n')
else
    accuracyRate = calc_accuracy(message, bitRate, Mapset, noisePower, test);
    fprintf('noise power = %.2f\n', noisePower);
    fprintf('bit rate = %d\n', bitRate);
    fprintf('accuracy = %d\n', accuracyRate);
end

function [codedMessage, divisibleByBitRate, messageLength] = coding_amp(message, bitRate, Mapset, noisePower, test)
    charactersCount = 32;
    messageLength = strlength(message);
    totalBitsCount = 5*messageLength;
    
    if rem(totalBitsCount, bitRate)==0
        divisibleByBitRate=true;
    else
        divisibleByBitRate=false;
    end

    charactersToBits = strings(1, messageLength);
    signalsCount = 2^bitRate;

    for i=1:messageLength
        for j=1:charactersCount
            if message(i) == Mapset{1, j}
                charactersToBits(i) = Mapset(2, j);
                break;
            end
        end
    end

    charactersToBits=join(charactersToBits, '');
    charactersToBits=char(charactersToBits);
    tstart=0;
    tend=ceil(totalBitsCount/bitRate);
    fs=100;
    ts=1/fs;
    t=tstart:ts:tend-ts;

    codedMessage=0;
    for i=0:tend-1
        if (i+1)*bitRate<=totalBitsCount
            bits=charactersToBits(i*bitRate+1:(i+1)*bitRate);
        else
            bits = charactersToBits(i*bitRate+1:totalBitsCount);
        end
        codedMessage=codedMessage+(bin2dec(bits)/(signalsCount-1))*sin(2*pi*t).*(heaviside(t-i)-heaviside(t-i-1));
    end
    
    codedMessage=codedMessage+noisePower*randn(1, length(codedMessage));
    
    if ~test
        plot(t, codedMessage)
        xlabel 't'
        ylabel 'coded message'
    end

end

function decodedMessage = decoding_amp(codedMessage, bitRate, Mapset, divisibleByBitRate, messageLength, noisePower)
    fs=100;
    tend=length(codedMessage)/fs;
    tstart=0;
    ts=1/fs;
    t=tstart:ts:tend-ts;
    coefficientsCount=2^bitRate;
    charactersCount=32;

    xt=2*sin(2*pi*t);
    
    product=codedMessage.*xt;
    correlationResults=zeros(1, tend);
    
    for i=1:tend
        correlationResults(i)=0.01*sum(product(((i-1)*fs)+1:i*fs));
    end
    
    coefficients=zeros(1, coefficientsCount);
    
    for i=0:coefficientsCount-1
        coefficients(i+1)=i/(coefficientsCount-1);
    end

    messageBits=strings(1, tend);
    decodedMessage=strings(1, messageLength);
    
    if noisePower==0
       treshold=1/(((2^bitRate)-1)*2);
       for i=1:tend
            for j=1:coefficientsCount
                if abs(correlationResults(i)-coefficients(j))<treshold
                    if ~divisibleByBitRate && i==tend
                        messageBits(i)=dec2bin(j-1, 5*messageLength-bitRate*(i-1));
                    else
                        messageBits(i)=dec2bin(j-1, bitRate);
                    end
                    break;
                end
            end
        end 
    else
        for i=1:tend
            diff=1000;
            isEmpty=true;
            for j=1:coefficientsCount-1
                tmpdiff1=abs(correlationResults(i)-coefficients(j));
                tmpdiff2=abs(correlationResults(i)-coefficients(j+1));
                if tmpdiff2<tmpdiff1 && tmpdiff2<diff
                    default=j;
                    diff=tmpdiff2;
                end
                if tmpdiff1<tmpdiff2 && tmpdiff1<diff
                    default=j-1;
                    diff=tmpdiff1;
                end
                treshold=(coefficients(j)+coefficients(j+1))/2;
                if correlationResults(i)>=coefficients(j) && correlationResults(i)<=treshold
                    if ~divisibleByBitRate && i==tend
                        messageBits(i)=dec2bin(j-1, 5*messageLength-bitRate*(i-1));
                    else
                        messageBits(i)=dec2bin(j-1, bitRate);
                    end
                    isEmpty=false;
                    break;
                end
                if correlationResults(i)<=coefficients(j+1) && correlationResults(i)>treshold
                    if ~divisibleByBitRate && i==tend
                        messageBits(i)=dec2bin(j, 5*messageLength-bitRate*(i-1));
                    else
                        messageBits(i)=dec2bin(j, bitRate);
                    end
                    isEmpty=false;
                    break;
                end
            end
            if isEmpty
                if ~divisibleByBitRate && i==tend
                    messageBits(i)=dec2bin(default, 5*messageLength-bitRate*(i-1));
                else
                    messageBits(i)=dec2bin(default, bitRate);
                end
            end
        end
    end

    messageBits=join(messageBits, '');
    messageBits=char(messageBits);
    
    for i=1:messageLength
        for j=1:charactersCount
            if Mapset{2, j} == messageBits((i-1)*5+1:(i*5))
                decodedMessage(i)=Mapset{1, j};
                break;
            end
        end
    end

end

function accuracyRate = calc_accuracy(message, bitRate, Mapset, noisePower, test)
    mistakesCount=0;
    for i=1:100
        [codedMessage, divisibleByBitRate, messageLength]=coding_amp(message, bitRate, Mapset, noisePower, test);
        decodedMessage = decoding_amp(codedMessage, bitRate, Mapset, divisibleByBitRate, messageLength, noisePower);
        decodedMessage=join(decodedMessage, '');
        decodedMessage=char(decodedMessage);
        if decodedMessage~=message
            mistakesCount=mistakesCount+1;
        end
    end
    accuracyRate=(100-mistakesCount);
end