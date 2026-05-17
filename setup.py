import setuptools

setuptools.setup(
    name = 'smoke_task',
    version = '0.0.0',
    install_requires = [
        'hy >= 1',
        'thoughtforms @ git+https://github.com/Kodiologist/ThoughtForms.git#a6ae5c822040a0c72a5d8202d843e680a21ba5a2'],
    packages = setuptools.find_packages(),
    package_data = dict(incompat_task = [
        'consent', 'prolific.hy', 'task.hy']))
