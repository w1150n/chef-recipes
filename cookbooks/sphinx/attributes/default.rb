set[:sphinx][:version]="sphinx-0.9.9"
set[:sphinx][:tar_file_checksum]="bf8f55ffc095ff6b628f0cbc7eb54761811140140679a1c869cc1b17c42803e4"
set[:sphinx][:url]="http://www.sphinxsearch.com/downloads/#{sphinx[:version]}.tar.gz"
set[:sphinx][:src_path]="/opt/src"
set[:sphinx][:tar_file]="#{sphinx[:src_path]}/#{sphinx[:version]}.tar.gz"
set[:sphinx][:configure_options]="--with-libstemmer"

