.. _Contributing:

Contributing
============

To contribute to the DateTime Library source code or documentation you will need to have a Github account. Sign up at `www.Github.com <https://www.github.com>`_ if you don't have a Github account already.

Requirements
------------
DateTime Library uses RadASM IDE for the projects hosted in the **DateTime-x86** folder and the **DateTime-x64** folder.

For x86 assembler projects:

- Install `RadASM <http://www.softpedia.com/get/Programming/File-Editors/RadASM.shtml>`_
- Install `MASM32 SDK <http://www.masm32.com/>`_

For x64 assembler projects:

- Install `UASM <http://www.terraspace.co.uk/uasm.html>`_
- Install `UASM-for-RadASM <https://github.com/mrfearless/UASM-with-RadASM>`_
- Install `UASM-SDK <https://github.com/mrfearless/UASM-SDK>`_

DateTime Library uses `readthedocs <https://readthedocs.org/>`_ for hosting the documentation. This requires the installation of python, and some python extensions.

- Install `Python <https://www.python.org/downloads/>`_
- Open a command prompt/terminal and type :

   - ``pip install sphinx``
   - ``pip install sphinx_rtd_theme``
   - ``pip install recommonmark``


DateTime Library Github Repository
----------------------------------

To work with the DateTime Library source and/or documentation files you will need to first clone or fork the DateTime Library repository using a git GUI client or using git commands in a command prompt/terminal. The DateTime Library repository is located at: `https://github.com/mrfearless/DateTime-Library <https://github.com/mrfearless/DateTime-Library>`_

The workflow for users is:

For users who are already authorized contributors: 

- Clone the DateTime Library repository locally
- Make changes
- Commit changes back to the DateTime Library repository

For users who are not authorized contributors, but who wish to contribute:

- Fork the DateTime Library repository to your own github account.
- Clone that repository locally
- Make changes
- Commit changes back to your version hosted on your account
- Submit a pull request - which will generate a pending commit on the original DateTime Library repository. This pending commit can be reviewed by the Author and/or other authorized persons and accepted or rejected.
- At some later stage, if changes have occurred on the DateTime Library repository, and if you are to keep up to date with these changes, then instead of deleting your repo version and reforking the DateTime Library, you can rebase your version to sync with the latest changes. Some GUI git clients may offer this as an upstream, which will allow you to sync with the main repository.


Editing the DateTime Library source files
-----------------------------------------

Once the requirements above have been met and the repository has been cloned/forked, you are ready to edit and make changes to the DateTime Library source files: 

- The DateTime Library source and RadASM project for MASM x86 assembler are stored in **DateTime-x86** folder.
- The DateTime Library source and RadASM project for UASM x64 assembler are stored in **DateTime-x64** folder.

Make your edits to the source files, and then once finished you are ready to submit changes


Editing the DateTime Library documentation files
------------------------------------------------

The DateTime Library documentation is stored in the **docs** folder. All the files in that folder and sub-folders are **.rst** files (reStructuredText) and are similar to markdown files. See the `reStructuredText Primer  <http://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html>`_ for details of usage. 

Once any changes you have made are saved, you can preview the changes locally by generating the html files:

- Open a command prompt/terminal and change to the DateTime Library **docs** directory (for example: ``cd "c:\Github\DateTime-Library\docs"``)
- Generate the html files by typing ``make html``
   
The sphinx builder will create a **build** folder inside the DateTime Library **docs** folder automatically (if it doesn't exist already) and will create an **html** folder under that. Inside this **html** folder is the html files including the **index.html** which you can open to locally preview your changes.


.. note:: The **build** folder won't be included in any pull requests or commits, as its automatically ignored. You can safely ignore this folder, or delete it if you wish, as it will be built automatically each time you run ``make html``


Submitting Changes
------------------

Once your happy with your changes, you can then commit to your locally cloned repository and submit a pull request on the DateTime Library on the Github website on your Github account. For authorized contributors you can just commit directly to the DateTime Library repository.