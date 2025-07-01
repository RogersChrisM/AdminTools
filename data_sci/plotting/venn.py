from matplotlib_venn import venn2, venn2_circles, venn3, venn3_circles
import matplotlib.pyplot as plt

def plot_venn2(a,b,ab,labels=None,outName=None):
    #plot 2-circle venn diagram
    # a  = A_only,
    # b  = B_only,
    # ab = A_and_B
    if labels is None:
        venn2_circles(subsets = (a,b,ab))
    else:
        venn2(subsets = (a,b,ab), set_labels = labels)
    if outName is None:
        plt.savefig(f'venn2.pdf',format='pdf')
        plt.savefig(f'venn2.png')
    else:
        plt.savefig(f'{outName}.pdf', format='pdf')
        plt.savefig(f'{outName}.png')
    
def plot_venn3(a,b,ab,c,ac,bc,abc,labels=None,outName=None):
    #plot 3-circle venn diagram
    # a   = A_only,
    # b   = B_only,
    # ab  = A_&&_B,
    # c   = C_only,
    # ac  = A_&&_C,
    # bc  = B_&&_C
    # abc = A_&&_B_&&_C
    if labels is None:
        print("LABELS IS NONE")
        venn3_circles(subsets = (a,b,ab,c,ac,bc,abc))
    else:
        venn3(subsets = (a,b,ab,c,ac,bc,abc), set_labels = labels)
    if outName is None:
        plt.savefig('venn3.pdf', format='pdf')
        plt.savefig('venn3.png')
    else:
        plt.savefig(f'{outName}.pdf', format='pdf')
        plt.savefig(f'{outName}.png')
        
if __name__=='__main__':
    print("Not for standalone use.")
    exit(1)
# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2025-06-26
# SHA256: f4c6bacc3de7bf180bf8e24700bcfa9f7ed7510a12c8970a05f1c679230ba1b2
