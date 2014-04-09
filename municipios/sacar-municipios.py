import sys 

print ""
print "*** Extractor de municipios y codigos de un documento de censo electoral ***"
print "****************************************************************************"
print ""
 
try:
	#Abrimos el archivo que se pasa como argumento
	f = open(sys.argv[1])

	
	print "Abriendo "+str(sys.argv[1])
	print ""

	#Leemos los todas las lineas del archivo
	lines = f.readlines()
	f.close();

	#Abrimos el archivo en el que vamos a escribir
	f2 = open("municipios.csv","w")
	resultado=""
	num_municipios=0
	i=0

	#Cabecera del archivo CSV
	f2.write("NOMBRE MUNICIPIO,CODIGO PROVINCIA,CODIGO MUNICIPIO\n")

	#Recorremos todas las lineas del fichero
	while i<len(lines):
		#Separamos cada palabra dentro de la linea
	    palabras = lines[i].split(' ')

	    #Si es un municipio
	    if(palabras[0]=="MUNICIPIO:"):
			num_municipios+=1
			#Recorremos el resto de la linea que corresponde al nombre del municipio
			for x in xrange(1,len(palabras)):
				#construimos el string con el municipio
				resultado=resultado+palabras[x]+" "

			#Quitamos los caracteres raros como el \n
			resultado=resultado.rstrip()
			fin=False
			x=i
			#Recorremos las lineas siguientes buscando el codigo del municipio
			while not fin:
				x=x+1
				
				#Almacenamos la siguiente linea separando las palabras
				codigos=lines[x].split(' ')
				j=0

				#Buscamos el codigo del municipio que debe empezar por el codigo de la provincia
				while(j<len(codigos) and not fin):
					if(codigos[j][:2]=="18"):
						#separamos los codigos de provincia y municipio
						resultado=resultado+","+codigos[j][:2]+","+codigos[j][2:5]
						fin=True
					j=j+1
			f2.write(resultado+"\n")

	    i=i+1
	    resultado=""


	f2.close()
	print "Numero de municipios: "+str(num_municipios)
	print ""
	print "Resultado guardado en municipios.csv"

except IOError, e:
	print "Error al abrir el archivo"