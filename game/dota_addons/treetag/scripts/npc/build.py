from os import listdir
from os.path import isfile, join
srcPath = "abilities_kv/"

output = open("npc_abilities_custom.txt", "w");
output.write("\"DOTAAbilities\"\n{\n\t\"Version\"\t\t\"1\"\n\n");

for file in [ f for f in listdir(srcPath) if isfile(join(srcPath,f)) ]:	
	for line in open(join(srcPath,file),"r"):
		output.write("\t"+line)

output.write("\n\n}\n");