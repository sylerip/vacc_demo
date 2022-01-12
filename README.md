# vacc_demo


This project contained a custom library writen in GO Lang and the Library has been compiled to Objective-C. 

As there are some difference between simulator and phyical devices, there are file need to be change before running on differnet platform.

The Steps are as follow:

1. Go into the following file path: /zpkBulletproof-objc/Bulletproofs.framework/Versions/A

2. Remove the File "Bulletproofs"

3a. For IOS devices, duplicate file "Bulletproofs_IOS" and rename the new file to "Bulletproofs"

3b. For simulator, duplicate file "Bulletproofs_sim" and rename the new file to "Bulletproofs"

4. Afterward, the project can be run on the selected platforms separatly.

Remarks: As there is some json formate changed, removing the test add on simulator or test device is recommanded.



Logic for current implementation:
1. When user select to hide Dose 2's date, zkp proof and the 3 month date range will be created and embedded in the QR code.
	- For case that Dose 2's date is less than 14 days, the proof will not be created.
2. When verify scan the QR code, the proof will be verify and the date range will be shown as the date od Dose 2.

As StardandRPProve required a Int as for inpuut, the Dose 2's Date will be translate to "Input = Today - Dose 2's Date" for Demo purposes
