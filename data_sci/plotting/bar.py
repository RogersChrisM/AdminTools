import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

def plot_bar(
    df,
    x,
    y,
    outName='bar',
    hue=None,
    title=None,
    xlabel=None,
    ylabel=None,
    color_palette='Set2',
    show_values=True,
    figsize=(10, 6),
    rotation=45
):
    """
    Plots a single or grouped bar plot.

    Parameters:
    - df (pd.DataFrame): The input data.
    - x (str): Column name for x-axis (categories).
    - y (str): Column name for y-axis (values).
    - hue (str, optional): Column name for grouping. If None, a single bar plot is created.
    - title (str): Title of the plot.
    - xlabel (str): Label for x-axis.
    - ylabel (str): Label for y-axis.
    - color_palette (str or list): Seaborn color palette.
    - show_values (bool): Whether to show value labels on bars.
    - figsize (tuple): Figure size.
    - rotation (int): Rotation for x-axis labels.
    """
    def cap_label(label):
        label=str(label)
        if label and label[0].isalpha():
            return label[0].upper() + label[1:]
        else:
            return label
            
    sns.reset_defaults()
    plt.figure(figsize=figsize)
    ax = sns.barplot(data=df, x=x, y=y, hue=hue, palette=color_palette)
    
    labels=[item.get_text() for item in ax.get_xticklabels()]
    new_labels=[cap_label(label) for label in labels]
    ax.set_xticklabels(new_labels)

    if show_values:
        for container in ax.containers:
            ax.bar_label(container, fmt='%.2f', label_type='edge', padding=3)
    
    if title is not None:
        ax.set_title(title)
    ax.set_xlabel(xlabel if xlabel else x)
    ax.set_ylabel(ylabel if ylabel else y)
    ax.tick_params(axis='x', rotation=rotation)

    if hue:
        ax.legend(title=hue)

    plt.tight_layout()
    plt.savefig(f'{outName}.pdf',format='pdf')
    plt.savefig(f'{outName}.png')

if __name__ == '__main__':
    print("Not for standalone use.")
    exit(1)
