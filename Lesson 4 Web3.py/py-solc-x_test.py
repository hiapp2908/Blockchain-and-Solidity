import solcx
from solcx import compile_standard

# with open("SimpleStorage.sol","r") as file:
#     simple_storage = file.read()
#     print(simple_storage)

solcx.install_solc(version="0.6.0",show_progress=True)
# print(solcx.get_solcx_install_folder())
#
# print(solcx.get_installed_solc_versions())
