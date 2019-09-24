import argparse

#  FPGA clock freqency for AccDNN support 1000Mhz/N (N >= 5)
#  Following table find an acceptable freqency for AccDNN
freqency_table = [  (250, 10, 250, 2, 2),
                    (200, 10, 200, 3, 2),
                    (166.7, 10, 166.7, 3, 3),
                    (142.8, 8, 142.8, 4, 3),
                    (125, 5, 125, 4, 4),
                    (111, 4, 111, 5, 4),
                    (100, 4, 100, 5, 5),
                    (90, 2, 90, 6, 5),
                    (83, 2, 83, 6, 6),
                    (76.9, 1, 77, 7, 6),
                    (71.4, 1, 72, 7, 7),
                ]
def get_clock_config (timing_file, output_file):
    mfile = open(timing_file, 'r')

    clock_table_begin = False
    clk_acc_line = None

    while True:
        lines = mfile.readlines (1000)
        if not lines :
            break        
        for line in lines:
            if line.find("| Intra Clock Table") == 0:
                clock_table_begin = True
            if (clock_table_begin):
                if line.find("clk_acc") == 0:
                    clk_acc_line = line
                    break

    mfile.close()
    if (not clk_acc_line) :
        print "Can not find available timing information from file %s" % timing_file
        return False

    WNS = None
    TNS = None
    if (clk_acc_line):
        print clk_acc_line
        clock_data = clk_acc_line.split()
        if len(clock_data) > 10:
            WNS = float(clock_data[1])
            TNS = float(clock_data[2])
        else:
            print "Can not find available timing information from file %s" % timing_file
            return False

    print "WNS:%f; TNS:%f" % (WNS, TNS)
    period = 5.0-WNS
    freqency = 1000.0/period

    for config in freqency_table:
        if (freqency >= config[0]):
            final_freqency = config [2]
            pll_posedge_cnt = config [3]
            pll_negedge_cnt = config [4]
            break
        elif abs(freqency - config[0]) < config[1]:
            final_freqency = config [2]
            pll_posedge_cnt = config [3]
            pll_negedge_cnt = config [4]
            break

    print "PIE works at frequency %fHz. Clock config is (%d,%d)" % (final_freqency, pll_posedge_cnt, pll_negedge_cnt)
    mfile = open(output_file, 'w')
    mfile.write("%d,%d,1024" % (pll_posedge_cnt, pll_negedge_cnt))
    mfile.close()
    print "PIE run-time config file is saved to %s" % output_file
    return True

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    # Required arguments: input and output files.
    parser.add_argument(
        "timing_file",
        help="simulated results file."
    )
    parser.add_argument(
        "output_file",
        help="real results file."
    )
    args = parser.parse_args()

    #timing_file = "psl_fpga_timing_summary.rpt"
    #output_file = "pie-run.conf"
    get_clock_config (args.timing_file, args.output_file)


