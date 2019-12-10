# -*- coding: utf-8 -*-
"""
Created on Fri Dec  6 18:36:00 2019

@author: juanr
"""

import rdkit.Chem
from rdkit.Chem import Descriptors
import csv

desc = {'HeavyAtomMolWt': 0,
        'ExactMolWt' : 0,
        'HeavyAtomCount': 0}

with open('dataset_Chembl_Cytokines.csv', 'r') as f:
    datos = csv.reader(f)
    for i in datos:
        if i[1] != 'CANONICAL_SMILES' and i[3] == 'IC50 (nM)' and i[5] == 'Homo sapiens':
            desc['HeavyAtomMolWt'] = rdkit.Chem.Descriptors.HeavyAtomMolWt(rdkit.Chem.MolFromSmiles(i[1]))
            desc['ExactMolWt'] = rdkit.Chem.Descriptors.ExactMolWt(rdkit.Chem.MolFromSmiles(i[1]))
            desc['HeavyAtomCount'] = rdkit.Chem.Descriptors.HeavyAtomCount(rdkit.Chem.MolFromSmiles(i[1]))

## https://www.rdkit.org/docs/GettingStartedInPython.html#descriptor-calculation
# https://www.rdkit.org/docs/GettingStartedInPython.html#list-of-available-descriptors
