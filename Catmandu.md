
# Catmandu - Importing, transforming, storing and indexing data should be easy

Swissbib 6 November 2014 Basel, Switzerland

Johann Rolschewski

Staatsbibliothek zu Berlin, Germany

## Metadata

![Katalog](./img/code4lib.png "Katalog")

## Metadata

... catalogued in library specific formats (MARC21, MAB2, PICA+, ...) 

... provided via library specific APIs (OAI, SRU, Z39.50, ...)

... used in diverse systems (OPACs, discovery systems, institutional repositories, link resolvers, ...)

## Demand

... for a library specific metadata toolkit

## LibreCat

... is an open collaboration of the three university libraries of Lund, Gent and Bielefeld

## Catmandu

... provide the open source set of programming components to build up digital libraries and research services 

... import data from various sources

... map the fields to a common data model

... store/index data in databases or search engines

... export data in various formats

## Catmandu - core concepts

* **Items** are the basic unit of data processing in Catmandu. Items may be read, stored, and accessed in many forms.

* **Importers** are Catmandu packages to read items into an application. One can also import from remote sources for instance via Atom and OAI-PMH endpoints.

* **Fixes** transforms items, massage the data into any format you like.

* **Stores** are databases and search engines to store/index your data.

* **Exporters** are Catmandu packages to export items from an application.

* **Iterables** are the bread and butter of Catmandu. Every stream of data, if it comes from Iterators, Fixes or Stores is an iterator. Iterators can be connected to other iterators to make processing chains. With Iterators the memory consumption of your program is low: you can process Gigabytes, Terabytes of input data without ever running out of memory.

## Importer/Exporter

AlephX BibTeX MAB2 MARC PICA

Atom CSV JSON RDF XLS XML YAML

## Importer for APIs

getJSON

OAI

SRU

Z39.50

## Stores

CHI

DBI

Elasticsearch

MongoDB

Solr

## CLI

```terminal
catmandu <command> [-DIL] [long options...]
    -D --debug          
    -L --load_path      
    -I --lib_path       

Available commands:

       commands: list the application's commands
           help: display a command's help screen

         config: export the Catmandu config
        convert: convert objects
          count: count the number of objects in a store
           data: store, index, search, import, export or convert objects
         delete: delete objects from a store
         export: export objects from a store
  exporter_info: list installed Catmandu exporters
       fix_info: list installed Catmandu fixes
         import: import objects into a store
  importer_info: list installed Catmandu importers
    module_info: list installed perl modules in a given namespace
           move: move objects to another store
           repl: interactive shell for Catmandu
     store_info: list installed Catmandu stores
```

## CLI - convert()

```terminal
catmandu convert [-?hLv] [long options...]

examples:

cat books.json | catmandu convert JSON to CSV --fields id,title

options:

        -? -h --help        this usage screen
        -L --load_path
        -v --verbose
```

## CLI - convert()

```terminal
$ cat ./shared/journals_mab2.dat | catmandu convert MAB2 to JSON

$ catmandu convert MAB2 to JSON < ./shared/journals_mab2.dat

$ catmandu convert MAB2 --type XML to JSON < ./shared/journals_mab2.xml
```

## CLI - convert()

```terminal
$ catmandu convert MARC to JSON < ./shared/camel.mrc

$ catmandu convert MARC --type RAW to JSON < ./shared/camel.mrc

$ catmandu convert MARC --type XML to JSON < ./shared/camel.xml
```

## CLI - convert()

```terminal
$ catmandu convert PICA to YAML < ./shared/pica.xml

$ catmandu convert PICA to JSON < ./shared/pica.xml
```

## CLI - convert()

```terminal
$ catmandu convert CSV to YAML < ./shared/eu_elections_2014.csv 

$ catmandu convert CSV to CSV --fields Wahlbezirk,DKP,NPD < ./shared/eu_elections_2014.csv 

$ catmandu convert YAML to JSON < ./shared/journals.yml
```

## CLI - convert()

```terminal
$ catmandu convert MAB2 --fix ./shared/mab2rdf.fix to CSV --file mab2.csv --fields dc_identifier,dc_title,dc_language < ./shared/journals_mab2.dat

$ catmandu convert MAB2 --fix ./shared/mab2rdf.fix to XLS --file mab2.xls --fields dc_identifier,dc_title,dc_language < ./shared/journals_mab2.dat
```

## CLI - convert()

```terminal
$ cat ./shared/test.tt
[%- FOREACH f IN record %]
[% _id %] [% f.shift %][% f.shift %][% f.shift %][% f.join(":") %]
[%- END %]

$ catmandu convert MARC to Template --template ./shared/test.tt < ./shared/camel.mrc

$ cat ./shared/marc.tt
[% _id %] [% dc.creator.0 %]: [% dc.title %]

$ catmandu convert MARC --fix ./shared/marc.fix to Template --template ./shared/marc.tt < ./shared/camel.mrc
```

## CLI - convert()

see https://gbv.github.io/aREF/aREF.html and https://metacpan.org/pod/RDF::aREF

```cmd
catmandu convert RDF --file ./shared/zdb_resources.rdf to YAML
catmandu convert MAB2 --type RAW --fix ./shared/mab2rdf.fix to RDF --type ttl < ./shared/mab2.dat
catmandu convert MAB2 --type RAW --fix ./shared/mab2rdf.fix to RDF --type xml < ./shared/mab2.dat
```

## CLI - import()

```terminal
catmandu import [-?hLv] [long options...]

examples:

catmandu import YAML --file books.yml to MongoDB 
    --database_name items --bag book

options:

        -? -h --help        this usage screen
        -L --load_path
        -v --verbose
```

## CLI - import()

```terminal
$ catmandu import MARC --type RAW --fix ./shared/marc.fix to MongoDB --database_name marc --bag marc < ./shared/camel.mrc

$ catmandu import MAB2 --fix ./shared/mab2rdf.fix to MongoDB --database_name mab --bag mab  < ./shared/journals_mab2.dat

$ mongo
> use marc
> db.marc.find()

$ catmandu import MARC --type RAW --fix ./shared/marc.fix to Elasticsearch --index_name marc --bag marc < ./shared/camel.mrc

$ catmandu import MAB2 --fix ./shared/mab2rdf.fix to Elasticsearch --index_name mab --bag mab < ./shared/journals_mab2.dat

$ curl 'http://localhost:9200/mab/_search?q=*'
```

## CLI - export()

```terminal
catmandu export [-?hLqv] [long options...]

examples:

catmandu export MongoDB --database_name items --bag book to YAML

options:

        -? -h --help        this usage screen
        -L --load_path
        -v --verbose
        -q --query
        --limit
```

## CLI - export()

```terminal
$ catmandu export MongoDB --database_name mab --bag mab to JSON

$ catmandu export Elasticsearch --index_name marc --bag marc to JSON

$ catmandu export Elasticsearch --index_name mab --bag mab --query '_id:"http://example.org/1142708-5"'

```

## CLI - count()

```terminal
catmandu count [-?hLq] [long options...]

examples:

catmandu count Elasticsearch --index_name shop --bag products 
    --query 'brand:Acme'

options:

        -? -h --help        this usage screen
        -L --load_path
        -q --query
```

## CLI - count()

```terminal
$ catmandu count MongoDB --database_name mab --bag mab

$ catmandu count MongoDB --database_name marc --bag marc --query '{"dc.creator": "Wall, Larry."}'

$ catmandu count Elasticsearch --index_name mab  --bag mab
$ catmandu count Elasticsearch --index_name mab --bag mab --query 'dc_title:"magazin"'

$ catmandu count Elasticsearch --index_name marc --bag marc --query 'dc.creator:"wall"'
```

## CLI - delete()

```terminal
catmandu delete [-?hLq] [long options...]

examples:

catmandu delete Elasticsearch --index_name items 
    --bag book -q 'title:"Programming Perl"'

options:

        -? -h --help        this usage screen
        -L --load_path
        -q --query
```

## CLI - delete()

```terminal
$ catmandu delete MongoDB --database_name mab --bag mab

$ catmandu delete Elasticsearch --index_name mab

$ catmandu delete MongoDB --database_name marc --bag marc --query '{"dc.creator": "Wall, Larry."}'

$ catmandu delete Elasticsearch --index_name mab --bag mab --query '_id:"http://example.org/1142708-5"'
```

## CLI - move()

```terminal
catmandu move [-?hLqv] [long options...]

examples:

catmandu move MongoDB --database_name items --bag book 
    to Elasticsearch --index_name items --bag book

options:

        -? -h --help        this usage screen
        -L --load_path
        -v --verbose
        -q --query
        --limit
```

## CLI - move()

```terminal
$ catmandu move MongoDB --database_name marc --bag marc to Elasticsearch --index_name moved --bag moved

$ catmandu move MongoDB --database_name marc --bag marc --query '{"dc.creator": "Wall, Larry."}' to Elasticsearch --index_name moved --bag moved

$ catmandu move Elasticsearch --index_name mab --bag mab --query '_id:"http://example.org/1142708-5"' to Elasticsearch --index_name selected --bag selected
```

## CLI - data()

```terminal
catmandu data [-?hLqv] [long options...]

        -? -h --help         this usage screen
        -L --load_path
        --from-store
        --from-importer
        --from-bag
        --count
        --into-exporter
        --into-store
        --into-bag
        --start
        --limit
        --total
        -q --cql-query
        --query
        --fix                fix expression(s) or fix file(s)
        --replace
        -v --verbose
```

## CLI - data()

```terminal
$ catmandu data --from-store MongoDB --from-database_name marc --from-bag marc --query '{"dc.creator": "Wall, Larry."}'

$ catmandu data --from-store Elasticsearch --from-index_name marc --query "dc.creator:\"Wall, Larry.\""

$ catmandu data --from-store Elasticsearch --from-index_name mab --from-bag mab --cql-query "publisher exact Heise"

$ catmandu data --from-store Elasticsearch --from-index_name mab --from-bag mab --cql-query "issued > 2009" --into-exporter YAML

$ catmandu data --from-store Elasticsearch --from-index_name mab --from-bag mab --cql-query "issued > 2009" --into-exporter CSV --fix 'retain_field("_id")'
```

## CLI - APIs

```terminal
$ catmandu convert OAI --url http://pub.uni-bielefeld.de/oai to JSON

$ catmandu convert SRU --base http://sru.gbv.de/gvk --recordSchema picaxml --parser picaxml --query "pica.iss=0939-4362" to JSON    

$ http://search.cpan.org/~voj/Catmandu-Importer-getJSON-0.1.1/lib/Catmandu/Importer/getJSON.pm
```

## Fix

... easy data manipulation by non programmers

... small Perl DSL language

## Fix - Path

```perl
$append   - Add a new item at the end of an array
$prepend  - Add a new item at the start of an array
$first    - Syntactic sugar for index '0' (the head of the array)
$last     - Syntactic sugar for index '-1' (the tail of the array)
```

## Fix - marc_map

```perl
    marc_map('008_/35-38','language');
    marc_map('100','authors.$append');
    marc_map('245[10]a','title');
    marc_map('500a','publisher');
    marc_map('650a','subject', -join => '; ');
    remove_field('record');
```

## Fix - mab_map

```perl
mab_map('001','identifier');
mab_map('002[a]','date');
mab_map('037[b]','language');
mab_map('050[ ]','format');
mab_map('052[ ]_/0-0','type');
mab_map('331[ ]','title');
mab_map('406jk','coverage.$append', -join => ' - ');
mab_map('700[bc]','subject.$append');
remove_field('record');
```

## Fix - pica_map

```perl
pica_map('001A0','date');
pica_map('010@a','language');
pica_map('009Qa','primaryTopicOf.$append');
pica_map('027A[01]a','furtherTitle');
remove_field('record');
```

## Fix - field

```perl
add_field('name','Smith');
# { name => 'Smith' }
set_field('name','Doe');
# { name => 'Doe'}
copy_field('name','title');
# { name => 'Doe, John', title => 'Dr.' }
remove_field('title');
# { name => 'Doe, John' }
move_field('name','dc.creator');
# { 'dc.creator' => 'Doe, John' }
retain_field('dc.creator')
# delete every field except named field
```

## Fix - field
```perl
# { subjects => 'Perl,R,JavaScript' }
split_field('subjects',',');
sort_field('subjects');
# { subjects => ['JavaScript', 'Perl', 'R'] }
join_field('subjects','; ');
# { subjects => 'JavasSript; Perl; R' }
```

## Fix - string
```perl
# { name => 'Doe'}
upcase('name');
# { name => 'DOE' }
downcase('name');
# { name => 'doe' }
capitalize('name');
# { name => 'Doe' }
append('name',', John');
# { name => 'Doe, John' }
prepend('name',', Dr. ');
# { name => 'Dr. Doe, John' }
```

## Fix - string
```perl
# { name => ' Doe,  '}
trim('name');
# { name => 'Doe,' }
trim('name','nonword');
# { name => 'Doe' }
substring('name', 0, 1);
# { name => 'D' }
```

## Fix - string
```perl
# {format => 'MARC21'}
replace_all('format', '\d', '');
# {format => 'MARC'}    

# {id => ['123-4', '567-X']}
replace_all('id.*', '-[0-9xX]$', '');
# {id => ['123', '567']}
```

## Fix - count & sum
```perl
# { numbers => [1, 2, 3] }
copy_field('numbers','count');
count('count');
copy_field('numbers','sum');
sum('sum');
# { numbers => [1, 2, 3], count => 3, sum => 6 }
```

## Fix - dictionaries
```terminal
$ cat dict.csv
004,Informatik
310,Statistik
510,Mathematik
```
```perl
# { ddc => '004' }
lookup('ddc', 'dict.csv', -default=>'Allgemeines');
lookup('ddc', 'dict.csv', -delete=>'1');
# { ddc => 'Informatik' }

lookup_in_store('ddc', 'MongoDB', -database_name => 'lookups');
```

## Fix - conditions
```perl
if_exists('ddc');
    lookup('ddc', 'dict.csv',  -delete=>'1');
end();

unless_exists('ddc');
    add_field('ddc', '000');
end();

if_any_match('ddc', '004');
    set_field('subject', 'Informatik');
end();

unless_any_match('subject', '[a-zA-Z]+');
    lookup('subject', 'dict.csv',  -delete=>'1');
end();
```

## Fix - nested data structures

```perl
add_field('dc.title','code4lib');
add_field('dc.subject.$append', 'Computer');
add_field('dc.subject.$append', 'Informatik');
add_field('dc.subject.$append', 'Bibliothek');
add_field('dc.identifier.$append.zdbid','2415107-5');
add_field('dc.identifier.$append.ocn','502377032');
add_field('dc.identifier.$append.issn','1940-5758');
remove_field('dc.identifier.$first');
remove_field('dc.subject.1');
remove_field('dc.subject.*');
```

## Fix - nested data structures
```perl
# Collapse deep nested hash to a flat hash
collapse();

# Expand flat hash to deep nested hash
expand();               

# Clone the perl hash and work on the clone
clone();
```

## Fix - cmd

```perl
# Use an external program that can read JSON 
# from stdin and write JSON to stdout
cmd("java MyClass");
```

## config

```
$ cat catmandu.yml
---
store:
  mdb:
   package: MongoDB
   options:
    database_name: mydb
  els:
   package: Elasticsearch
   options:
    index_name: mydb
  sol:
   package: Solr
   options:
    url: http://localhost:8983/solr

$ catmandu import JSON to mdb < records.json
$ catmandu import MARC to els < records.mrc
$ catmandu import YAML to sol < records.yaml
$ catmandu export mdb to JSON
$ catmandu export els to JSON
$ catmandu export sol
```

## Extensions

```bash
├── Catmandu
│   ├── Cmd
│   │   └── foo.pm
│   ├── Exporter
│   │   ├── Foo.pm
│   ├── Fix
│   │   ├── foo_map.pm
│   ├── Importer
│   │   ├── Foo.pm
│   ├── Store
│   │   ├── Foo
│   │   │   ├── Bag.pm
│   │   │   └── Searcher.pm
│   │   ├── Foo.pm
```

## CMD

```perl
package Catmandu::Importer::Hello;

use Catmandu::Sane;
use Moo;
with 'Catmandu::Importer';

sub generator {
    my ($self) = @_;
    state $fh = $self->fh;
    state $n = 0;
    return sub {
        my $line = $self->readline or return;
        my ($name) = split( ',', $line );
        return $name
            ? { "hello" => $name }
            : { "hello" => 'World' };
    };
}

1;
```

## Fix

```perl
package Catmandu::Fix::hello_world;

use Moo;

sub fix {
    my ($self,$data) = @_;

    $data->{hello} = 'World';

    return $data;
}

1;
```

## CMD

```perl
package Catmandu::Cmd::hello_world;
use parent 'Catmandu::Cmd';
 
sub command_opt_spec {
   (
       [ "greeting|g=s", "provide a greeting text" ],
   );
}
 
sub description {
   <<EOS;
examples:
catmandu hello_world --greeting "Hoi"
options:
EOS
}
 
sub command {
   my ($self, $opts, $args) = @_;
   my $greeting = $opts->greeting // 'Hello';
   print "$greeting, World!\n"
}
 
1;
```

## Extensions

```terminal
catmandu -I ./lib convert Hello < ./shared/names.csv 
catmandu -D -I ./lib convert Hello --fix "hello_world()" 
    < ./shared/names.csv
catmandu -I ./lib hello_world --greeting Moin
```

# Links

http://librecat.org

http://librecat.org/Catmandu/

http://metacpan.org/release/Catmandu

http://github.com/LibreCat/Catmandu


