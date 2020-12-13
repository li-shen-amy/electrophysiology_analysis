import numpy as np
import matplotlib.pyplot as plt

def read_single_lvb(filename, rec_len, trial_num, ch_num = 16, Fs = 30000):
    """read a single .lvb file and convert it to .bin Data for OfflineSorter Process
    or convert it to nwb data format
    inputs:
        filename: *.lvb filename to be processed (directory and extension (.lvb) included)
        rec_len: recording segment time length (Sec)
        trial_num:
        ch_num: channel number (Default: 16)
        Fs: sample rate (Default: 30000 Hz)
        output_format: 'bin': .bin binary data for OfflineSorter
                                (Plexon Inc.: https://plexon.com/products/offline-sorter/);
                        'nwb': nwb object for further processing (NeurodataWithoutBorders: http:www.nwb.org)
        output_name: filename for save (directory and extension (.lvb) included)
    """

    rec_dots = int(Fs * rec_len)
    # single (float32, 4byte) precision, big-endian
    dt = np.dtype('>f4')
    timeserial = np.fromfile(filename, dtype=dt, count=-1, sep='', offset=0)
    assert trial_num == int(len(timeserial)/rec_dots/ch_num)
    timeserial = timeserial.reshape((rec_dots, ch_num, trial_num), order='F')


    # for preview
    fig = plt.figure(figsize=(8, 5))
    for i in range(16):
        ax1 = fig.add_subplot(8, 2, i + 1)
        ax1.plot(np.linspace(0, 1, Fs), timeserial[0:Fs, i, 1])
    plt.show(True)
    plt.close()
