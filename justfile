target := "vss"
archive_name := target + "_" + os() + "_" + arch()
# refs: https://github.com/casey/just/blob/master/examples/cross-platform.just
archive_dir := if os_family() == "windows" { archive_name } else { "dist" / archive_name }
windows_archive_cmd := "powershell Compress-Archive -Path {{archive_dir}} -DestinationPath {{archive_dir}}.zip"
unix_archive_cmd := "tar -zcvf {{archive_dir}}.tar.gz {{archive_dir}} && mv {{archive_dir}}.tar.gz dist"
archive_cmd := if os_family() == "windows" { windows_archive_cmd } else { unix_archive_cmd }

# default recipe to display help information
default:
	@just --list

# setup vss project
setup:
	v install .

# run test
test:
	v test .

# format v files
fmt:
	v fmt -w .

# report suspicious code constructs
vet:
	v vet .

# generate module document
doc:
	v doc -o docs/ -f markdown .

# clean files
clean:
	rm -rf dist

# create archive file
archive:
	mkdir -p dist
	mkdir -p {{archive_dir}}
	cp README.md {{archive_dir}}
	{{archive_cmd}}
	rm -rf {{archive_dir}}

# dist
dist:
	just clean
	just build
	just archive

# build vss
build:
	v . -o {{target}}

# build vss for production
build-prod:
	v -prod . -o {{target}}

# build & run example
example:
	rm -rf example/vss
	just build
	cp {{target}} example/
	task

# run vss build command
example-run:
	cd example && ./vss build

