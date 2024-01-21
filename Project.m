clc; close all; clear;

% Objective 1: Visual Analysis of Phonetics (Time Domain)
[y, Fs] = audioread('Recording.wav');
t = (0:(length(y) - 1)) / Fs;
figure('Name', 'Time Domain Analysis: Visual Analysis of Phonetics');
plot(t, y);
xlabel('Time (s)');
ylabel('Amplitude');
title('Time Domain Representation of the Recorded Voice Signal');

% Objective 2: Effect of LPF Filtering in Time Domain
LPF_cutoff = 300;  % Low-pass filter cutoff frequency in Hz
[b_lpf, a_lpf] = butter(2, LPF_cutoff / (Fs / 2), 'low');
y_lpf = filter(b_lpf, a_lpf, y);
% player = audioplayer(y_lpf, Fs);
% play(player);
figure('Name', 'Time Domain Analysis: Effect of Low-Pass Filtering');
plot(t, y_lpf);
xlabel('Time (s)');
ylabel('Amplitude');
title('Time Domain Representation after Low-Pass Filtering');

% Objective 3: Effect of HPF Filtering in Time Domain
HPF_cutoff = 7000;  % High-pass filter cutoff frequency in Hz
[b_hpf, a_hpf] = butter(2, HPF_cutoff / (Fs / 2), 'high');
y_hpf = filter(b_hpf, a_hpf, y);
% player = audioplayer(y_hpf, Fs);
% play(player);
figure('Name', 'Time Domain Analysis: Effect of High-Pass Filtering');
plot(t, y_hpf);
xlabel('Time (s)');
ylabel('Amplitude');
title('Time Domain Representation after High-Pass Filtering');

% Objective 4: Segregate Voice and Un-voice Parts (Time Domain)
voice_threshold = 0.0004;  % Amplitude of noise from spectrum of Recording is approx = 0.0004
voice_signal = y_lpf .* (abs(y_lpf) > voice_threshold);
unvoice_signal = y_lpf .* (abs(y_lpf) <= voice_threshold);
% player = audioplayer(voice_signal, Fs);
% play(player);
figure('Name', 'Time Domain Analysis: Segregation of Voice and Un-Voice Parts');
subplot(2, 1, 1);
plot(t, voice_signal);
xlabel('Time (s)');
ylabel('Amplitude');
title('Voice Part (Low-Pass Filtered)');
subplot(2, 1, 2);
plot(t, unvoice_signal);
xlabel('Time (s)');
ylabel('Amplitude');
title('Un-Voice Part (Low-Pass Filtered)');

% Objective A: Visual Analysis about the Frequency Details (Frequency Domain)
N = length(y);
w = linspace(-pi, pi, N);
Yw = fftshift(fft(y, N));
figure('Name', 'Frequency Domain Analysis: Visual Analysis about Frequency Details');
plot(w / pi, abs(Yw));
xlabel('Normalized Frequency');
ylabel('Magnitude');
title('Frequency Domain Representation of the Recorded Voice Signal');

% Objective B: Effect of LPF Filtering in Frequency Domain
Yw_lpf = fftshift(fft(y_lpf, N));
figure('Name', 'Frequency Domain Analysis: Effect of Low-Pass Filtering');
plot(w / pi, abs(Yw_lpf));
xlabel('Normalized Frequency');
ylabel('Magnitude');
title('Frequency Domain Representation after Low-Pass Filtering');

% Objective C: Effect of HPF Filtering in Frequency Domain
Yw_hpf = fftshift(fft(y_hpf, N));
figure('Name', 'Frequency Domain Analysis: Effect of High-Pass Filtering');
plot(w / pi, abs(Yw_hpf));
xlabel('Normalized Frequency');
ylabel('Magnitude');
title('Frequency Domain Representation after High-Pass Filtering');

% Objective D: Segregate Voice and Un-voice Parts (Frequency Domain)
frequency_threshold = 0.0004;  % Adjust the threshold as needed

voice_mask = abs(Yw) > frequency_threshold * max(abs(Yw));  % same method as time domain
unvoice_mask = ~voice_mask;

Yw_voice = Yw .* voice_mask;
Yw_unvoice = Yw .* unvoice_mask;

voice_signal_freq = ifft(ifftshift(Yw_voice));
unvoice_signal_freq = ifft(ifftshift(Yw_unvoice));

% player = audioplayer(voice_signal_freq, Fs);
% play(player);

figure('Name', 'Frequency Domain Analysis: Segregation of Voice and Un-Voice Parts');
subplot(2, 1, 1);
plot(t, voice_signal_freq);
xlabel('Time (s)');
ylabel('Amplitude');
title('Voice Part (Frequency Domain Segregation)');
subplot(2, 1, 2);
plot(t, unvoice_signal_freq);
xlabel('Time (s)');
ylabel('Amplitude');
title('Un-Voice Part (Frequency Domain Segregation)');