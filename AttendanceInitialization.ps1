#Initialize Variables 

$className = "II-BSc-Zoology"

$desktopPath = [Environment]::GetFolderPath("Desktop")
$attendanceDir = $desktopPath + "\Attendance"
$googleRecordDir = $attendanceDir + "\GoogleMeetRecord"
$classDir = $attendanceDir + "\" + $className
$attendanceFile = $attendanceDir + "\" + $className + "\" + "AttendanceRecorder" + ".ps1"
$classListFile = $attendanceDir + "\" + $className + "\" + $className + ".txt"


#Declare Functions 

function check-path($directoryPath) {

    return (Test-Path -Path $directoryPath)

}


function create-directory($directoryPath) {
    
    New-Item -ItemType "directory" -Path $directoryPath

}

function directory-check($directoryPath) {

    Write-Output "Checking Directory $directoryPath"

    if(check-path -directoryPath $directoryPath) {

        Write-Output "Directory Exists"

    }

    else  {
    
    create-directory -directoryPath $directoryPath

    }

}

#Function Call

#directory-check -directoryPath $attendanceDir
directory-check -directoryPath $googleRecordDir
directory-check -directoryPath $classDir

#Add class list File if doesnt exist 
if (check-path -directoryPath $classlistfile) {

Write-Output "Class List File exists; Kindly add the register number of your students"

}

else {

New-Item -Path $classlistfile -ItemType "file" -Value "Add RegisterNumber of your class"

Write-Output "Kindly add the register number of your students"

}


#Initializing Attendance Recorder file
$aprecorder = '
#Initialize Variables
$className = "II-Bsc-zoology"

$desktopPath = [Environment]::GetFolderPath("Desktop")
$attendanceDir = $desktopPath + "\Attendance"
$googleRecordDir = $attendanceDir + "\GoogleMeetRecord"
$classDir = $attendanceDir + "\" + $className
$classListFile = $attendancedir + "\" + $className + "\" + $className + ".txt"

$check = 0;
$outputFile = @()
$absentees = @()

#Output file location, ensure the directory exists
$fileName = $className + "-Absentees-" + (Get-Date -Format "dd-MM-yyyy") + ".csv"
$fileName = "$classDir\" + $fileName


#Once the meeting is over, run the script immediately, files are fetched based on last modified date
$inputFile = Get-ChildItem -Path $googleRecordDir -Filter *.csv| sort LastWriteTime  | select -last 1
$inputFile = $inputFile.FullName

$inputFile = Get-Content -Path $inputFile
$classList = Get-Content -Path $classListFile

#Fetch all the students who have attended the class
for ($i = 0; $i -lt $inputFile.Count; $i++) {
    
    $temp = $inputFile[$i]
    $firstentry = $temp.Split() 
    
    if($firstentry[0].Length -ge 1) {
        
        $outputFile += $firstentry[0]

    }

}


#Fetch Absentees List
for ($i = 0; $i -lt $classList.Count; $i++)  {
    
    $check = 0;
    
    for ($j = 0; $j -lt $outputFile.Count; $j++) {
        
        if($outputFile[$j] -match $classList[$i]) {

        $check = 1

        }

    }

    if ($check -eq 0) {

    $absentees += $classList[$i]

    }
}


#$absentees.Count

#Output variable to File

$absentees | Out-File $fileName
'

#Creating attendance Recorder file if doesnot exists

if (check-path -directoryPath $attendanceFile) {

    Write-Output "Attendance Recorder File exists; Kindly modify classname"

}

else {

New-Item -Path $attendanceFile -ItemType "file" -Value "$aprecorder"
Write-Output "Kindly modify classname if required"

}

Write-Host "Press any key to continue ....."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")