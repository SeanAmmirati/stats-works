# -*- coding: utf-8 -*-
"""
Created on Wed Aug  1 21:24:57 2018
@author: Sean Ammirati
Various simple function to show documentation strategy.
"""

__all__ = ['find_third_value']

import os 


def find_third_value(unsorted):
    """ find_third_value

    An example function to show NumPy documentation standards. Finds the
    third value in a list.

    Parameters
    ----------
    unsorted : list
        a list which has at least three elements

    Returns
    -------
    object
        The value in the third index of the list.

    Examples
    --------
    >>> find_third_value([1,2,3])
    3
    >>> find_third_value([])
    Traceback (most recent call last):

    File "<ipython-input-3-8605eb7fc497>", line 1, in <module>
      find_third_value()
    """
    if not isinstance(unsorted, list):
        raise ValueError('You must pass a list.')
    if len(unsorted) < 3:
        raise ValueError('The list is too short.')

    val = unsorted[2]
    return val


def main():
    find_third_value([1, 2, 3])
    find_third_value('bobby')
    find_third_value([2, 3, 'fun', 5, 'girls', 2])
    find_third_value([1, 100])


if __name__ == "__main__":
    main()
