use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'unfk',
    VERSION_FROM => 'lib/unfk.pm',
    PREREQ_PM    => {
        'Test::More' => 0,
    },

    EXE_FILES    => ['script/unfk'],

    PM           => {
        'lib/unfk.pm'     => '$(INST_LIBDIR)/unfk.pm',
        'lib/session.pm'  => '$(INST_LIBDIR)/session.pm',
    },
);
