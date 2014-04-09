import sys 

print "*** Extractor de municipios y codigos de un documento de censo electoral ***"
print "****************************************************************************"
print ""
 
try:
	f = open(sys.argv[1])

	lines = f.readlines()
	f.close();
	f2 = open("municipios.csv","w")
	resultado=""
	num_municipios=0
	i=0

	f2.write("NOMBRE MUNICIPIO,CODIGO PROVINCIA,CODIGO MUNICIPIO\n")

	while i<len(lines):
	    palabras = lines[i].split(' ')
	    if(palabras[0]=="MUNICIPIO:"):
			num_municipios+=1
			for x in xrange(1,len(palabras)):
				resultado=resultado+palabras[x]+" "

			resultado=resultado.rstrip()
			fin=False
			x=i
			while not fin:
				x=x+1
				codigos=lines[x].split(' ')
				j=0
				while(j<len(codigos) and not fin):
					if(codigos[j][:2]=="18"):
						resultado=resultado+","+codigos[j][:2]+","+codigos[j][2:5]
						fin=True
					j=j+1
			f2.write(resultado+"\n")

	    i=i+1
	    resultado=""


	f2.close()
	print "Numero de municipios: "+str(num_municipios)

except IOError, e:
	print "Error al abrir el archivo"