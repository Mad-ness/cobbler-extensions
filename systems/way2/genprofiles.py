#!/usr/bin/env 

# -*- codepage: utf-8

import os
import json
import yaml
import jinja2
import argparse


template_file = "template.yaml"
systems_file = "systems.yaml"


def loadyaml2dict(filename): return yaml.load(open(filename, 'r'))
def loadfile2plain(filename): return open(filename, 'r').read()
def render_template(buffer, vars={}): return jinja2.Template(buffer).render(vars)
def yaml2dict(buffer): return yaml.load(buffer)
def dict2humantext(buffer): return json.dumps(buffer, indent=4)


def render_systems2plain():
    systems_plaindefs = loadfile2plain(systems_file)
    systems_vars = load_vars(systems_plaindefs)
    return render_template(systems_plaindefs, { 'vars': systems_vars })

def load_vars(buffer):
    data = yaml2dict(buffer)
    result = {}
    if data is not None and 'vars' in data.keys(): result = data['vars']
    return result

def render_systems2yaml():
    # get rendered systems file just a text
    systemsfile_plaintext = render_systems2plain()
    # convert it to a dict structure, vars are here as well 
    # but vars are not needed
    systems_defs_yaml = yaml2dict(render_template(systemsfile_plaintext, {}))

    
    list_ready_systems = []
    if 'systems' in systems_defs_yaml.keys():
        # load a Cobbler system template
        system_template = loadfile2plain(template_file)
        sysnames = []
        for sys in systems_defs_yaml['systems']:
            sysnames.append(sys['name'])
            with open(sys['name'] + '.output.yaml', 'w') as fd:
                fd.write(render_template(system_template, sys))
        print("Processed systems:\n - " + "\n - ".join(sysnames))
            
def menu():


    f1 = 'template.yaml'
    f2 = 'systems.yaml'

    parser = argparse.ArgumentParser(description = "Building Cobbler suitable systems files from short YAML definitions")

    parser.add_argument("-s", "--systems-file", default=f2, help="Name of a file within systems defitions at YAML syntax (default: %s)" % f2)
    parser.add_argument("-t", "--template-file", default=f1, help="Template file that to be used for making output config files (default: %s)" % f1)
    #parser.add_argument("-o", "--overwrite", action='store_false', dest="boolean_switch", default=False, help="Overwrite an output file in place if it exists")

    args = parser.parse_args()

    template_file = args.template_file
    systems_file = args.systems_file

    render_systems2yaml()

if __name__ == "__main__":
    menu()
    exit(0)

