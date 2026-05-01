package unfk;
our $VERSION = '0.01';


sub new {
    my $class = shift;
    my $target = shift;

    my $self = {
        _tty => $target->{tty},
        _command => $target->{command},
    };
    bless $self, $class;
    return $self;
}

#---

sub locate_pid {
    my ($self) = @_;
    my $pid_to_command;
    my $command = $self->{_command};

    my $processes = `ps -ef`;
    my @process_list = split (/\n/, $processes);

    foreach my $entry (@process_list) {
        my ($UID, $PID, $PPID, $C, $STIME, $TTY, $TIME, $CMD) = split(/\s+/, $entry, 8);
        $pid_to_command->{$PID}->{"command"}= "$CMD";
        $pid_to_command->{$PID}->{"tty"}= "$TTY";
    }      

    my $retval;
    my $match_count = 0;
    my $multiple_results;
    print "\n";
    foreach my $process_id (keys %$pid_to_command) {
        if ($pid_to_command->{$process_id}->{command} eq $command) {
            print "TTY: $pid_to_command->{$process_id}->{tty}\n";
            print "  Process ID: $process_id\n";
            print "    Command: $pid_to_command->{$process_id}->{command}\n---\n";
            $multiple_results->{$process_id} = $pid_to_command->{$process_id}->{tty};
            $match_count +=1;
        }
    }
            if ($match_count == 1) {
	        my ($pidkey) = keys %$multiple_results;
		return $pidkey;
            } elsif ($match_count >= 1) {
                print "\nselection:\n";
		my $n = 0;
		my $n_ext;

                foreach my $found_pid (keys %$multiple_results) {
                  print "$n) ", $found_pid, " : ";
		  print $multiple_results->{$found_pid}, "\n";
		  $n_ext->{$n} = $found_pid;
		  $n +=1;
                }

		my $choice = <STDIN>;
		chomp $choice;
		die "incorrect choice" if ! $n_ext->{$choice};
		return $n_ext->{$choice};

            } else {
                print "somethings gone horribly wrong\n";
            }

}


#---

sub kill_pid {
    my $self = shift;
    my $pid = shift;
    print "Options)\n";
    print "1)graceful\n2)kill\n3)int\n";
    chomp(my $choice = <STDIN>);

    my %signals = (
        1 => 'TERM',
        2 => 'KILL',
        3 => 'INT',
    );
    if (kill 0, $pid) {
    #Process is alive, killing

        if (exists $signals{$choice}) {
            my $result = kill $signals{$choice}, $pid;

            if ($result) {
            print "Signal $signals{$choice} sent to PID $pid\n";
            } else {
            print "Failed to send signal (check PID or permissions)\n";
            }
        
        } else {
        print "Invalid option\n";
        }

    } else {
    print "Process not running or no permission\n";
    }
}

1;
