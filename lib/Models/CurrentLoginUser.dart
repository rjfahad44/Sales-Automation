class CurrentLoginUser{

  String userName = "", globalArea = "", contactNo = "",
      bankName = "", employeeCode = "", unit = "", jobStation = "",  jobType = "",
      designation = "", department = "", address = "", customerLine = "",
      phoneNumber = "", territoryName = "", supervisor = "",cArea = "",token = "";

  double cLat = 0.1, cLon = 0.1, jLat = 0.0, jLon = 0.0, salary = 0.0;
  int userID = 0, unitID = 0, jobstationID = 0, supervisorEnroll = 0, territoryID = 0, officerLevel = 0;
  DateTime joiningDate = DateTime.now(), dateOfBirth = DateTime.now();

  CurrentLoginUser(this.userName, this.globalArea, this.contactNo, this.bankName,
      this.employeeCode, this.unit, this.jobStation, this.jobType, this.designation, this.department,
      this.address, this.customerLine, this.phoneNumber, this.territoryName, this.supervisor, this.cArea, this.token, this.cLat, this.cLon, this.jLat, this.jLon, this.salary,
      this.userID, this.unitID, this.jobstationID, this.supervisorEnroll, this.territoryID, this.officerLevel, this.joiningDate, this.dateOfBirth);


}