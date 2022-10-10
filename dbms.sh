#!/bin/bash
shopt -s extglob

datatyps=( "string" "number" );

checktbl () {
	valid=false
	all=`ls`
	for one in $all
	do
		
		if [ $one == $1 ]
		then
				valid=true;
		fi
	
	done
	echo $valid
}

valtyp () {
if [ $1 == "number" ]
then
        case $2 in
                +([0-9]) )

                echo true;
                ;;
                *)
                echo false;
                ;;
        esac

else
        case $2 in
                +([a-zA-Z0-9]) )
                echo true;
                ;;
                *)
                echo false;
                ;;
        esac
fi
}

valprim () {
valid=true
prims=`awk -F" " '{if ($1 != "tblconfig") {split($1, a, ":"); print a[2]}}' $2`

for prim in $prims
do
	if [ $1 == $prim ]
	then
		valid=false
	fi
done

echo $valid
}

chkatr () {
	check=false;
	config=`sed -n '/^tblconfig/p' $1 | cut -d " " -f 2-`
	for conf in $config
	do
		atr=`echo $conf | awk -F':' '{print $1}'`;
		typ=`echo $conf | awk -F':' '{print $2}'`;
		if [ $2 == $atr ]
		then
			check=( "true" $typ );
		fi
	done
	echo ${check[*]};
}


valid=true;
all=`ls -ad .*`;
for one in $all
do
	if [ $one == ".dbms" ]
	then
        	valid=false;
        fi
done
if [ $valid == true ]
then
	mkdir .dbms
fi
cd .dbms

while true
do
	ans=$(zenity --cancel-label "Close" --ok-label "Select" --list --width 250 --height 230 --title "Main Menu"  --text "Choose an option" --radiolist  --column "Pick" --column "Option" TRUE "Create Database" FALSE "List Databases" FALSE "Connect To Databases" FALSE "Drop Database" FALSE "exit");

	case $ans in
			"Create Database")
		#=============================================================================================
		namec=$(zenity --entry --width 300 --title="Creating Database" --text="Enter Database name:")
		
		if [ ${#namec} -eq 0 ]
		then
			continue
		fi
		
			valid=$(checktbl $namec)
			
			
				if [ $valid == true ]
				then
					zenity --width 300 --error --text="Database $namec already exists."
				fi
		

		if [ $valid == false ]
		then
			mkdir $namec;
			zenity --width 300 --title="Success" --info --text="$namec Created successfully.";
		fi
					;;
			"List Databases")
		#==============================================================================================
		all=`ls`
		numb=1;
		touch .list
		for one in $all
		do
				echo $numb"- "$one >> .list;
				(( numb=$numb+1 ));
		done
		zenity --text-info --title "Databases List" --height 400 --width 400 < <(cat .list);
		rm .list
					;;
			"Connect To Databases")
		#==============================================================================================
		namev=$(zenity --entry --width 300 --title="Connecting to Database" --text="Enter Database name:");

		if [ ${#namev} -eq 0 ]
		then
			continue
		fi
		
		valid=$(checktbl $namev)
						
		if [ $valid == true ]
		then
				cd $namev;
				zenity --width 300 --info --text="Connected to $namev successfully."
		fi


		if [ $valid == true ]
		then
		while true
		do
			ans2=$(zenity --cancel-label "Go Back" --ok-label "Select" --width 300 --height 300 --title $namev --list  --text "Choose an option" --radiolist  --column "Pick" --column "option" TRUE "Create table" FALSE "List tables" FALSE "Drop table" FALSE "Insert into table" FALSE "select from table"  FALSE "Delete from table"  FALSE "Update table" FALSE "main menu");
					case $ans2 in
							"Create table")
			#===========================================================================================
			
			tbl=$(zenity --entry --width 300 --title="Creating Table" --text="Enter Table name:");

			
			if [ ${#tbl} -eq 0 ]
			then
				continue
			fi
			
			valid=$(checktbl $tbl)

			if [ $valid == true ]
			then
					zenity --width 300 --error --text="$tbl already exist."
			
			fi
						
			if [ $valid == false ]
			then
				cancel=false

				num=$(zenity --entry --width 300 --title="Creating Table" --text="Enter number of attributes:");
				if [ ${#num} -eq 0 ]
				then
					cancel=true
					continue
				fi
				
				i=0
				atrv="";
				attrs="tblconfig "
				while [ $i -ne $num ]
				do
					while true
					do
						if [ $i == 0 ]
						then
							
							atr=$(zenity --entry --width 300 --title="Creating Table" --text="Enter your Primary Key:");
							if [ ${#atr} -lt 1 ]
							then
								cancel=true
								continue 3
							fi
						else
							atr=$(zenity --entry --width 300 --title="Creating Table" --text="Enter attribute name:");
							if [ ${#atr} -lt 1 ]
							then
								cancel=true
								continue 3
							fi
						fi

						repeated=false
						for a in $atrv
						do
							if [ $a == $atr ]
							then
								repeated=true
							fi
						done
						

						if [ $repeated == false ]
						then
							break
						else
							zenity --width 300 --error --text="$atr already exists."
						fi
					done
					atrv=$atrv$atr" "

					
					opt=$(zenity  --list --width 250 --height 230 --title "Main Menu"  --text "Choose an option" --radiolist  --column "Pick" --column "Option" TRUE "string" FALSE "number");
					if [ ${#opt} -lt 1 ]
					then
						cancel=true
						continue 2
					fi
					
						case $opt in
							"string")
							dt="string";
							;;
							"number")
							dt="number";
							;;
						esac

					attrs=$attrs$atr":"$dt" ";
					(( i=$i+1 ))
				done
				if [ $cancel == false ]
				then
					touch $tbl;
					echo $attrs > $tbl;
					zenity --width 300 --title="Success" --info --text="$tbl Created successfully.";
				fi
			fi
									;;
							"List tables")
			#==========================================================================================

									touch .list
									all=`ls`
									numb=1;
									for one in $all
									do

											echo $numb"- "$one >> .list;
												(( numb=$numb+1 ));
											
									done
									zenity --text-info --title "Tables list" --height 400 --width 400 < <(cat .list);
									rm .list
										;;
							"Drop table")
			#=============================================================================================
										
									dro=$(zenity --entry --width 400 --title="Drop Table" --text="Enter Table name:");
									valid=false
									if [ ${#dro} -eq 0 ]
									then
										continue
									fi
									
									valid=$(checktbl $dro)

									if [ $valid == true ]
									then
											rm $dro;
											zenity --width 300 --title="Success" --info --text="Table "$dro" droped sucssefuly.";
									else
											zenity --width 300 --error --text="Table $dro does not exist."
									fi
										;;
							"Insert into table")
			# ========================================================================
			
						tbl=$(zenity --entry --width 400 --title="Inserting row to Table" --text="Enter Table name:");

						if [ ${#tbl} -eq 0 ]
						then
						continue
						fi
						row="";
						valid=$(checktbl $tbl)

						if [ $valid == true ]
						then
						config=`sed -n '/^tblconfig/p' $tbl | cut -d " " -f 2-`
						for conf in $config
						do
							typ=`echo $conf | awk -F':' '{print $2}'`;
							atr=`echo $conf | awk -F':' '{print $1}'`;
							prim=0
						
							while [ true ]
							do
								
									if val=$(zenity --entry --width 400 --title="Inserting Value" --text="Enter $atr value with type ( $typ ):")
									then
										val=$val
									else
										continue 3
									fi

								get=$(valtyp "$typ" "$val")

								if [ $prim -eq 0 ]
								then
									get2=$(valprim "$val" "$tbl")
								else
									get2=true
								fi

								if [ $get == true -a $get2 == true ]
								then
									row=$row$atr":"$val" ";
									break
								elif [ $get == false ]
								then
									zenity --width 300 --error --text="Wrong data type!!."
								elif [ $get2 == false ]
								then
									zenity --width 300 --error --text="Primary key must be unique!!."
								fi		
							done
						done
						
							echo $row >> $tbl;
							zenity --width 300 --title="Success" --info --text="Row added successfully.";

				else
					zenity --width 300 --error --text="Wrong Table Name."
				fi
			
						;;
							"select from table")
			#=========================================================================================
			tbl=$(zenity --entry --width 400 --title="Printing data from Table" --text="Enter Table name:");

			if [ ${#tbl} -eq 0 ]
			then
				continue
			fi
			valid=$(checktbl $tbl)
			touch .list.html
			touch .data

			if [ $valid == true ]
			then
						while true
						do
							atr=$(zenity --entry --width 400 --title="Select from table" --text="Enter attribute to select where:\nEnter "all" to select all");
												
							if [ ${#atr} -eq 0 ]
							then
								continue 2
							fi
							check=$(chkatr $tbl $atr)
							check=`echo $check | cut -d " " -f 1`;
							if [ $check == true -o $atr == "all" ]
							then
								break
							else
								zenity --error --width 300 --text="Wrong Attribute Name!!."
							fi
						done

						if [ $atr != "all" ]
						then
						
							if va=$(zenity --entry --width 400 --title="Select from table" --text="Enter attribute value where to select:");
							then
								val=$va
							else
								continue
							fi

							entry=$atr":"$val
							
							lines=`grep $entry $tbl | wc -l | cut -d " " -f 1`;
							zenity --info --width 300 --text="$lines Lines were selected."
							grep $entry $tbl > .data;
						else
							lines=`grep -v "^tblconfig" $tbl | wc -l | cut -d " " -f 1`;
							zenity --info --width 300 --text="$lines Lines were selected."
							grep -v "^tblconfig" $tbl > .data; 
						fi
			#___________________________________________________________________________________u__________________________________________________________
				#echo "===========================================================" >> .list.html
				printf "<!DOCTYPE html> <html lang=en> <body> <table border="2" cellspacing="5"> <tr> <th>#</th>" >> .list.html
				config=`sed -n '/^tblconfig/p' $tbl | cut -d " " -f 2-`
				for conf in $config
				do
					echo $conf | awk -F':' '{printf " <th>"$1"</th> "}' >> .list.html
				done
				printf "</tr>\n" >> .list.html

				#printf "\n===========================================================\n" >> .list.html
				chmod +rwx .list.html

				grep -v "^tblconfig" .data | awk -F" " ' BEGIN{ORS="<tr>"} {for ( i=1 ; i<=NF; i++) { if (NF == 1) {split($i, a, ":"); print "<td>"NR"-""</td> ""<td>"a[2]"</td> " } 
				else if (i == 1) {split($i, a, ":"); printf "<td>"NR"-""</td> ""<td>"a[2]"</td> "} 
				else if (i < NF ) {split($i, a, ":"); printf "<td>"a[2]"</td> "} 
				else { split($i, a, ":"); print "<td>"a[2]"</td> </tr>"} }} END{ printf "</table> </body> </html>"}' >> .list.html ;
				zenity --text-info --title $tbl --html --filename="$PWD/.list.html" --height 500 --width 500;
				rm .list.html;
				rm .data;

			else
				zenity --width 300 --error --text="Wrong Table Name."
			fi
									;;
							"Delete from table")
			#================================================================================================="
							tbl=$(zenity --entry --width 400 --title="Printing data from Table" --text="Enter Table name:");

							if [ ${#tbl} -eq 0 ]
							then
								continue
							fi
							valid=$(checktbl $tbl)

							if [ $valid == true ]
							then
								while true
								do
									atr=$(zenity --entry --width 400 --title="Delete from table" --text="Enter attribute to delete from:\nEnter "all" to delete all");
									if [ ${#atr} -eq 0 ]
									then
										continue 2
									fi
									check=$(chkatr $tbl $atr)
									check=`echo $check | cut -d " " -f 1`;
									if [ $check == true -o $atr == "all" ]
									then
										break
									else
										zenity --error --width 300 --text="Wrong Attribute Name!!."
									fi
								done

								if [ $atr != "all" ]
								then
									if val=$(zenity --entry --width 400 --title="Delete from table" --text="Enter attribute value where to delete:");
									then
										val=$val
									else
										continue
									fi

									entry=$atr":"$val
									lines=`grep $entry $tbl | wc -l | cut -d " " -f 1`;
									zenity --info --width 300 --text="$lines Lines was Deleted."
									grep -v $entry $tbl > .del;
									cat .del > $tbl
									rm .del;
								else
									lines=`grep -v "^tblconfig" $tbl | wc -l | cut -d " " -f 1`;
									zenity --info --width 300 --text="$lines Lines was Deleted."
									sed -n '/^tblconfig/p' $tbl > .del;
									cat .del > $tbl;
									rm .del;
								fi
								
							fi

									;;
							"Update table")
			#================================================================================================="
				tbl=$(zenity --entry --width 400 --title="Printing data from Table" --text="Enter Table name:");

							if [ ${#tbl} -eq 0 ]
							then
								continue
							fi
							valid=$(checktbl $tbl)

							if [ $valid == true ]
							then
								while true
								do
									atr=$(zenity --entry --width 400 --title="update from table" --text="Enter the attribute name you want to update:");
									if [ ${#atr} -eq 0 ]
									then
										continue 2
									fi

									check=$(chkatr $tbl $atr)
									typ=`echo $check | cut -d " " -f 2`;
									check=`echo $check | cut -d " " -f 1`;

									
									if [ $check == true ]
									then
										break
									else
										zenity --error --width 300 --text="Wrong Attribute Name!!."
									fi
									
								done

								if val=$(zenity --entry --width 400 --title="update from table" --text="Enter current attribute value:");
								then
									val=$val
								else
									continue
								fi

								while true
								do
									
									newval=$(zenity --entry --width 400 --title="update from table" --text="Enter new attribute value:")
									if [ ${#newval} -eq 0 ]
									then
										continue 2
									fi

									primary_k=`sed -n '/^tblconfig/p' $tbl | cut -d " " -f 2 | awk -F':' '{print $1}'`
									

									get=$(valtyp "$typ" "$newval")
									if [ $get == false ]
									then
										zenity --width 300 --error --text="Wrong data type!!."
										continue
									fi


									if [ $primary_k == $atr ]
									then
										get2=$(valprim "$newval" "$tbl")
										if [ $get2 == false ]
										then
											zenity --width 300 --error --text="Primary key must be unique!!."
											continue
										fi
									fi

									entry=$atr":"$val
									newentry=$atr":"$newval
				
									lines=`grep $entry $tbl | wc -l | cut -d " " -f 1`;
									zenity --info --width 300 --text="$lines Lines was updated."
									sed 's/'$entry'/'$newentry'/g' $tbl > .upd;
									cat .upd > $tbl;
									rm .upd;
									break
									done
								fi
									;;
		"main menu")
			cd ..
			break
		;;
		*)
			cd ..
			break
		;;
					esac
		done

		else
			zenity --error --width 300 --text="Wrong Name!!."
		fi
		;; # connect to db
			"Drop Database")
#================================================================================================
			named=$(zenity --entry --width 400 --title="Drop Database" --text="Enter Database name:");

		if [ ${#named} -eq 0 ]
		then
			continue
		fi
		valid=$(checktbl $named)

		if [ $valid == true ]
		then
			rm -r $named;
			zenity --width 300 --info --text="$named Dropped successfully."
		else
			zenity --width 300 --error --text="Wrong Name!!."
		fi
		;;
		"exit")
			break
		;;
		*)
			break
		;;
	esac
done
