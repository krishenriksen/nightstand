project(
    'nightstand',
    'vala', 'c',
    version: '0.0.1',
    meson_version: '>=0.45.0'
)

PROJECT_NAME = 'nightstand'
prefix = get_option('prefix')
libdir = join_paths(prefix, get_option('libdir'))
datadir = join_paths(prefix, get_option('datadir'))

VAPI_DIR = join_paths(meson.source_root(), 'vapi')
vala = meson.get_compiler('vala')

conf = configuration_data()
conf.set_quoted('PROJECT_NAME', PROJECT_NAME)
conf.set_quoted('PACKAGE_LIBDIR', libdir)
conf.set_quoted('PACKAGE_SHAREDIR', datadir)

config_h = configure_file(
	output: 'config.h',
	configuration: conf
)

config_dep = declare_dependency(
	dependencies: vala.find_library('config', dirs: VAPI_DIR),
	sources: config_h
)

config_inc_dir = include_directories('.')

NotificationCenterValaArgs = [
    '--pkg=config',
    '--vapidir=' + VAPI_DIR,
    '--target-glib=2.38',
]

# Create a new executable, list the files we want to compile, list the dependencies we need, and install
executable(
    meson.project_name(),
    'src/Application.vala',
    'src/Widgets/Calendar.vala',
    'src/Widgets/NowPlaying.vala',
    dependencies: [
        dependency('gtk+-3.0', version: '>=3.22'),
        dependency('cairo', version: '>=1.15.0'),
        meson.get_compiler('c').find_library('m', required: false)
    ],
    c_args: [
        '-DGMENU_I_KNOW_THIS_IS_UNSTABLE',
    ],
    vala_args: NotificationCenterValaArgs,
    include_directories: config_inc_dir,
    install: true
)

# Install CSS file
install_data(
    join_paths('data', 'nightstand.css'),
    install_dir: join_paths(datadir, PROJECT_NAME)
)

# Install icons
install_data(
    join_paths('data', 'Nightstand-moon.png'),
    install_dir: join_paths(datadir, PROJECT_NAME)
)
install_data(
    join_paths('data', 'Nightstand-clock.png'),
    install_dir: join_paths(datadir, PROJECT_NAME)
)
install_data(
    join_paths('data', 'Nightstand-close.png'),
    install_dir: join_paths(datadir, PROJECT_NAME)
)

install_data(
    join_paths('data', 'Nightstand-moon-night.png'),
    install_dir: join_paths(datadir, PROJECT_NAME)
)
install_data(
    join_paths('data', 'Nightstand-clock-night.png'),
    install_dir: join_paths(datadir, PROJECT_NAME)
)
install_data(
    join_paths('data', 'Nightstand-close-night.png'),
    install_dir: join_paths(datadir, PROJECT_NAME)
)
