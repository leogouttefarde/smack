
ZIP=setup.zip

all:
	zip ${ZIP} -r scripts
	md5sum ${ZIP}

md5:
	md5sum ${ZIP}

clean:
	rm -f ${ZIP}

