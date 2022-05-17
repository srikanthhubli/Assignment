# Agricultural supply chain Validation

1. Install Vagrant on ur local machine 
2. After installing travel to the existing folder and run vagrant up, vagrant ssh to login
3. Check sudo nano /etc/hosts for the ports exposed to the organizations farmersorg, logistics, srienterprices, priceauthority.
4. Install the setup scripts in /netwok/setup using the README file present in it 
5. run dev-init.sh -s to run with couchdb as the database
6. Go to src/token/qry/v3 and follow the README  file to add data to the network and query it
http://localhost:5984/_utils/
http://localhost:6984/_utils/
http://localhost:7984/_utils/
http://localhost:6984/_utils/
