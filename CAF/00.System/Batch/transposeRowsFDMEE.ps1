Param(
     [string]$path,
     [string]$importFile,
	 [string]$exportFile
)


#import data into array
$data = Import-Csv -Path $path\$importFile
$data | FT -AutoSize


# Creatre variable to store the output
$rows = @()

# Fields of interest

$rotate = "PERIOD" #  top
$keep = "UD1","UD2","UD3","ENTITY","UD4","UD5","SCENARIO","UD6","YEAR","UD7","ACCOUNT" #Sort
$value = "AMOUNT" # What to total


# Find the unique "Rotate" [top row of the pivot] values and sort ascending
#Hardcoded for months becuase I did not want them in alpabetical order

$pivots = "Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"


# Step through the original data...
#  for each of the "Keep" [left hand side] find the Sum of the "Value" for each "Rotate"

$data | 
  # group $GroupMe | 
   group $keep | 
    foreach { 
        $group = $_.Group 
        # Create the data row and name it as per the "Keep"
        $row = new-object psobject
        #You can create Custom Headers here if you want on Export
        $row  |add-member NoteProperty  ($keep[0]+","+$keep[1]+","+$keep[2]+","+$keep[3]+","+$keep[4]+","+$keep[5]+","+$keep[6]+","+$keep[7]+","+$keep[8]+","+$keep[9]+ ","+$keep[10]) $_.Name 
       
        # Cycle through the unique "Rotate" values and get the sum
        foreach ($pivot in $pivots)
        {
            $row | add-member NoteProperty $pivot ($group | where { $_.$rotate -eq $pivot } | measure -sum $value).Sum
        }
        
        $rows += $row
    } 




$rows | Export-Csv working.csv   -NoTypeInformation 
#Clean up Quotes
(get-content working.csv) | foreach-object {$_ -replace '"', ''} | set-content $path\$exportFile


Remove-Item working.csv

Remove-Item $path\$importFile