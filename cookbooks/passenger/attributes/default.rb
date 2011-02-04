default[:passenger][:version]="3.0.0"
default[:passenger][:passengermaxrequests]="128"
default[:passenger][:passengerpoolidletime]="300"
default[:passenger][:railsappspawneridletime]="600"

mem=(memory[:total].gsub("kB","")).to_i
case
when (mem <= 262144)
  default[:passenger][:passengermaxpoolsize]="2"
when (mem <= 524508)
  default[:passenger][:passengermaxpoolsize]="4"
when (mem <= 1048796)
  default[:passenger][:passengermaxpoolsize]="6"
when (mem <= 1572864)
  default[:passenger][:passengermaxpoolsize]="8"
when (mem <= 2097372)
  default[:passenger][:passengermaxpoolsize]="10"
when (mem <= 3145728)
  default[:passenger][:passengermaxpoolsize]="14"
when (mem <= 4194304)
  default[:passenger][:passengermaxpoolsize]="18"
else
  default[:passenger][:passengermaxpoolsize]="20"
end




