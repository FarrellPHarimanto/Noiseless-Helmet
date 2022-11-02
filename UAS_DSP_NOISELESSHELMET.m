close;
[y,Fs] = audioread('klakson_brisik.m4a'); %membaca file audio yang berisikan suara klakson dan suara brisik disekitarnya
%time domain
N = length(y);
Ts = 1/Fs ;
t = (0:N-1)*Ts;
sound(y,Fs); %output suara audio sebelum difilter
subplot(221)
plot(t,y); %plot grafik pada domain waktu (sebelum difilter)
title('Time Domain');
%frequency domain 
Y = abs(fft(y,1024)); %FFT file audio untuk mengubah domain waktu sinyal menjadi domain frekuensi 
f = Fs*(0:511)/1024;
subplot(222)
plot(f(1:512),Y(1:512)); %plot grafik audio pada domain frekuensi (sebelum difilter)
title('Frequency Domain');
pause
[b,a] = sos2tf(SOS,B); %memasukkan coefficient filter "B" dari filter designer yang sudah dirancang 
z = filter(b,a,y); 
sound(z,Fs); %output suara audio setelah difilter
subplot(223)
plot(z) %plot grafik pada domain waktu (sesudah difilter)
title('output signal time domain')
Z = fft(z,1024);
Zm = abs(Z);
f = Fs*(0:511)/1024;
subplot(224)
plot(f,Zm(1:512)) %plot grafik pada domain frekuensi (sesudah difilter)
title('output signal frequency domain')