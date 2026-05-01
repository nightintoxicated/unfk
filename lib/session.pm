package session;

sub prompt_user {
    my $max_count = shift;
    print "selection: ";
    my $sel = <STDIN>;
    
    die "unknown option" if $sel =~ "[a-zA-Z]";
    die "too high a number" if $sel >= $max_count;
    
    return $sel;
}



sub get_sessions {
    my $sessions;
    my $output = `w -hs`;
    my @lines = split(/\n/, $output);

    foreach my $line (@lines) {
        my ($user, $tty, $ip, $time, $command) = split(/\s+/, $line, 5);
        if ($command ne "w -hs") {
            $sessions->{"$tty"}->{"tty"} = $tty;

            $sessions->{"$tty"}->{"command"} = $command;
            $sessions->{"$tty"}->{"user"} = $user;
            $sessions->{"$tty"}->{"time"} = $time;
            $sessions->{"$tty"}->{"ip"} = $ip;
        }
    }

    return $sessions;
}



sub get_target {
    my $all_tty = shift;
    my @selectable_list;

    foreach my $key (keys %$all_tty) {
        my $kvp = {
            tty => $key,
            command => $all_tty->{$key}->{command},
        };
    push (@selectable_list, $kvp);
    }

    my $i = 0;
    print "choose a session\n";
    print "----------------\n";
    foreach my $entry (@selectable_list) {
    print "$i) TTY: $entry->{tty} | command: $entry->{command}\n";
    $i +=1;
    }
    
    my $req = prompt_user($i);
    my $ret = @selectable_list[$req];
    
    return $ret;
}



1;
