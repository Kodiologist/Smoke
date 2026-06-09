import setuptools

setuptools.setup(
    name = 'smoke_task',
    version = '0.0.0',
    install_requires = [
        'hy >= 1',
        'thoughtforms @ git+https://github.com/Kodiologist/ThoughtForms.git#cf79148af472c42433c956352ecda1f9a015e816',
        'metadict'],
    packages = setuptools.find_packages(),
    package_data = dict(smoke_task = [
        'consent', 'prolific.hy', 'task.hy']))
