import matplotlib.pyplot as plt

def plot_pie(labels, sizes, outName=None, title=None):
    """
    Creates and displays a pie chart.
    
    Parameters:
    - labels: list of category names (strings)
    - sizes: list of corresponding sizes (numbers)
    - title: (optional) title of the chart
    
    Example:
    create_pie_chart(['Apples', 'Bananas', 'Cherries'], [30, 45, 25])
    """
    def autopct_threshold(pct, threshold=5):
        return ('%1.1f%%' % pct) if pct > threshold else ''
    plt.figure(figsize=(6,6))
    patches, texts, autotexts = plt.pie(sizes, labels=None, autopct=lambda pct: autopct_threshold(pct, threshold=5), startangle=90)
    plt.legend(patches, labels, loc='best', bbox_to_anchor=(1,0.5))
    if title is not None:
        plt.title(title)
    plt.axis('equal')  # Equal aspect ratio ensures pie is circular.
    plt.tight_layout()
    if outName is None:
        plt.savefig('pie.pdf', format='pdf')
        plt.savefig('pie.png')
    else:
        plt.savefig(f'{outName}.pdf', format='pdf')
        plt.savefig(f'{outName}.png')

if __name__=='__main__':
    print("Not for standalone use")
    exit(1)
