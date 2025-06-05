import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

def plot_bar(
    df,
    x,
    y,
    hue=None,
    title="Bar Plot",
    xlabel=None,
    ylabel=None,
    color_palette="Set2",
    show_values=True,
    figsize=(10, 6),
    rotation=0
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
    plt.figure(figsize=figsize)
    ax = sns.barplot(data=df, x=x, y=y, hue=hue, palette=color_palette)

    if show_values:
        for container in ax.containers:
            ax.bar_label(container, fmt='%.2f', label_type='edge', padding=3)

    ax.set_title(title)
    ax.set_xlabel(xlabel if xlabel else x)
    ax.set_ylabel(ylabel if ylabel else y)
    ax.tick_params(axis='x', rotation=rotation)

    if hue:
        ax.legend(title=hue)
    else:
        ax.legend_.remove()

    plt.tight_layout()
    plt.show()

