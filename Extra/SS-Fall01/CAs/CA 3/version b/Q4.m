clc;
clear;
close all;

%4-1
charactersCount=32;
characters=['a':'z' ' ' '.' ',' '!' ';' '"'];
Mapset=cell(2, charactersCount);
for i=0:charactersCount-1
    Mapset{1, i+1}=characters(i+1);
    Mapset{2, i+1}=dec2bin(i, 5);
end

%4-2...4-8

bitRate=1;
noisePower=0;
message='signal';
test=false;

if ~test
    [codedMessage, divisibleByBitRate, messageLength, bitsFrequencies, charactersToBits]=coding_freq(message, bitRate, Mapset, noisePower, test);
    [decodedMessage, messageBits] = decoding_freq(codedMessage, bitRate, Mapset, divisibleByBitRate, messageLength, noisePower, bitsFrequencies);
    fprintf('decoded message is:\n')
    fprintf('%s', decodedMessage{:});
    fprintf('\n')
else    
    accuracyRate = calc_accuracy(message, bitRate, Mapset, noisePower, test);
    fprintf('noise power = %.2f\n', noisePower);
    fprintf('bit rate = %d\n', bitRate);
    fprintf('accuracy = %.2f\n', accuracyRate);
end

function [codedMessage, divisibleByBitRate, messageLength, bitsFrequencies, charactersToBits] = coding_freq(message, bitRate, Mapset, noisePower, test)
    charactersCount = 32;
    messageLength = strlength(message);
    totalBitsCount = 5*messageLength;
    
    if rem(totalBitsCount, bitRate)==0
        divisibleByBitRate=true;
    else
        divisibleByBitRate=false;
    end

    charactersToBits = strings(1, messageLength);
    frequenciesCount = 2^bitRate;

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
    bitsFrequencies=zeros(1, frequenciesCount);

    if frequenciesCount<50
        step=floor(49/frequenciesCount);
        startFrequency=floor((49-(frequenciesCount-1)*step)/2);
        for i=1:frequenciesCount
            bitsFrequencies(i)=startFrequency+(i-1)*step;
        end
    else
        for i=1:frequenciesCount
            bitsFrequencies(i)=rem(i, 50);
        end
    end

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
        f=bitsFrequencies(bin2dec(bits)+1);
        codedMessage=codedMessage+sin(2*pi*f*t).*(heaviside(t-i)-heaviside(t-i-1));
    end
    
    codedMessage=codedMessage+noisePower*randn(1, length(codedMessage));
    
    if ~test
        plot(t, codedMessage)
        xlabel 't'
        ylabel 'coded message'
    end

end

function [decodedMessage, messageBits] = decoding_freq(codedMessage, bitRate, Mapset, divisibleByBitRate, messageLength, noisePower, bitsFrequencies)
    fs=100;
    tend=length(codedMessage)/fs;
    frequenciesCount=2^bitRate;
    charactersCount=32;
    
    correlationResults=zeros(1, tend);
    
    for i=1:tend
        [maxfft, fmax]=max(abs(fftshift(fft(codedMessage((i-1)*fs+1:i*fs)))));
        correlationResults(i)=abs(fmax-51);
    end

    messageBits=strings(1, tend);
    decodedMessage=strings(1, messageLength);
    
    if noisePower==0
       for i=1:tend
            for j=1:frequenciesCount
                if correlationResults(i)==bitsFrequencies(j)
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
            diff=1000000000000;
            isEmpty=true;
            for j=1:frequenciesCount-1
                tmpdiff1=abs(correlationResults(i)-bitsFrequencies(j));
                tmpdiff2=abs(correlationResults(i)-bitsFrequencies(j+1));
                if tmpdiff2<tmpdiff1 && tmpdiff2<diff
                    default=j;
                    diff=tmpdiff2;
                end
                if tmpdiff1<tmpdiff2 && tmpdiff1<diff
                    default=j-1;
                    diff=tmpdiff1;
                end
                treshold=(bitsFrequencies(j)+bitsFrequencies(j+1))/2;
                if correlationResults(i)>=bitsFrequencies(j) && correlationResults(i)<=treshold
                    if ~divisibleByBitRate && i==tend
                        messageBits(i)=dec2bin(j-1, 5*messageLength-bitRate*(i-1));
                    else
                        messageBits(i)=dec2bin(j-1, bitRate);
                    end
                    isEmpty=false;
                    break;
                end
                if correlationResults(i)<=bitsFrequencies(j+1) && correlationResults(i)>treshold
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
    accuraciesSum=0;
    for i=1:100
        mistakesCount=0;
        [codedMessage, divisibleByBitRate, messageLength, bitsFrequencies, charactersToBits]=coding_freq(message, bitRate, Mapset, noisePower, test);
        [decodedMessage, messageBits] = decoding_freq(codedMessage, bitRate, Mapset, divisibleByBitRate, messageLength, noisePower, bitsFrequencies);
        n=length(messageBits);
        m=length(charactersToBits);
        for j=1:min(n, m)
            if messageBits(j)~=charactersToBits(j)
                mistakesCount=mistakesCount+1;
            end
        end
        accuraciesSum=accuraciesSum+(n-mistakesCount)/n;
    end
    accuracyRate=accuraciesSum/100;
end