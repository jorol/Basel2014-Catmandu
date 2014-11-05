package Catmandu::Importer::Hello;

use Catmandu::Sane;
use Moo;

with 'Catmandu::Importer';

sub generator {
    my ($self) = @_;
    state $fh = $self->fh;
    state $n = 0;
    return sub {
        $self->log->debug( "generating record " . ++$n );
        my $line = $self->readline or return;
        my ($name) = split( ',', $line );
        return $name
            ? { "hello" => $name }
            : $self->log->warn( "no name found for record " . $n );
    };
}

1;
