

/* funzioni utili alla validazione del campo dati */
function notEmpty(stringa) {
	//if (stringa === "") return false;
	if(stringa.length == 0) return false;
	return true;
}
function validateEmail(email) {
    var reEmail=/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@[\w]*\.[com|it|org]/;
    return reEmail.test(email);
}
function validateWord(name) {
    var reName = /^[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð]+$/;
    return reName.test(name);
}
function validatePhrase(name) {
    var reName = /^[a-zA-Z0-9àáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð.,;:!?()-]+$/;
    return reName.test(name);
}
function validatePhraseShort(name) {
    var reName = /^[a-zA-Z0-9àáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð.,;:-\s ]+$/;
    return reName.test(name);
}
function validateCardNumber(number){
	if(number.length>15) return false;
    var reNum = /[0-9]{15}/;
    return reNum.test(number);
}
function validatePhoneNumber(number){
	if(number.length>10) return false;
    var rePNum = /[0-9]{10}/;
    return rePNum.test(number);
}
/*****  TEST ****/
function validateDate(date){
	var anno=Number(date.substring(6, 10));
	var mese=Number(date.substring(3, 5));
	var giorno=Number(date.substring(0, 2));
	var day=new Date();
	if(anno<1900 || anno>day.getFullYear() || mese<1 || mese>12 || giorno<1 || giorno>31) return false; //controllo generale
	if((mese==4 || mese==6 || mese==9 || mese==11) && giorno>30) return false; //controllo
	if(mese==2 && anno%4!=0 && giorno>28) return false; //controllo anno bisestile
	if(mese==2 && anno%4==0 && giorno>29) return false; //controllo anno bisestile
    var reDate = /^(0[1-9]|[12][0-9]|3[01])[-.](0[1-9]|1[012])[-.](19|20)\d\d$/; //anni permessi: dal 1900 al 2099
    return reDate.test(date);
}

function validateCodiceFiscale(codice){
    var reCF = /^[A-Z]{6,6}[0-9][0-9][A-Z][0-9][0-9][A-Z][0-9][0-9][0-9][A-Z]$/;
    return reCF.test(codice);
}
function convertDate(date){
    return date.substring(6, 10) + "-" + date.substring(3, 5) + "-" + date.substring(0, 2);
}
function validatePassword(pwd){
    if(notEmpty(pwd) && pwd.length >= 8)
        {var rePwd = /^[a-zA-Z0-9]+$/; return rePwd.test(pwd);} 
    return false;
}
function validatePasswordRepeat(pwd, pwdr){
    if(pwd===pwdr)
        return true; 
    return false;
}


function setFocus(element){
    element.focus();
}



function checkEmail(){
	//window.alert("sono vivo");
    var email_user = document.getElementById("email_user");
	if(!notEmpty(email_user.value)){//se il campo è vuoto
		email_user.className="error";
		writeErrorEmpty(email_user,"email","en");
	}
	else{//campo non vuoto
		if(!validateEmail(email_user.value)){
			email_user.className="error";
			writeError(email_user,"email","non valida","en");
		}
		else{
			email_user.className="";
			removeErrorChildToANode(email_user);
		}
	}
}

function checkPassword(){
    var password_user = document.getElementById("password_user");
	if(!notEmpty(password_user.value)){//se il campo è vuoto
		password_user.className="error";
		writeErrorEmpty(password_user,"password","en");
	}
	else{//campo non vuoto
		if(!validatePassword(password_user.value)){
			password_user.className="error";
			writeError(password_user,"password","la password deve contenere almeno 8 caratteri","en");
		}
		else{
			password_user.className="";
			removeErrorChildToANode(password_user);
		}
	}
}

function checkPasswordRepeat(){
    var password_user_repeat = document.getElementById("password_user_repeat");
	if(!notEmpty(password_user_repeat.value)){//se il campo è vuoto
		password_user_repeat.className="error";
		writeErrorEmpty(password_user_repeat, "password","en");
	}
	else{//campo non vuoto
		if(!validatePasswordRepeat(document.getElementById("password_user").value, password_user_repeat.value)){
			password_user_repeat.className="error";
			writeError(password_user_repeat, "password","deve corrispondere a quella scritta sopra","en");
		}
		else{
			password_user_repeat.className="";
			removeErrorChildToANode(password_user_repeat);
		}
	}
}

function checkWord(obj, name){
	if(!notEmpty(obj.value)){//se il campo è vuoto
		obj.className="error";
		writeErrorEmpty(obj,name);
	}
	else{//campo non vuoto
		if(!validateWord(obj.value)){
			obj.className="error";
			writeError(obj, name, "sono ammesse solo lettere");
		}
		else{
			obj.className="";
			removeErrorChildToANode(obj);
		}
	}
}

function checkPhrase(obj, name){
if(name=="professione" || name=="città" || name=="indirizzo" ){
	if(!notEmpty(obj.value)){//se il campo è vuoto
		return;
	}
	else{//campo non vuoto
		if(!validatePhraseShort(obj.value)){
			obj.className="error";
			writeError(obj, name, "sono ammesse solo lettere, numeri e i seguenti simboli: .,;:-");
		}
		else{
			obj.className="";
			removeErrorChildToANode(obj);
		}
	}	
}else{
if(!notEmpty(obj.value)){//se il campo è vuoto
		obj.className="error";
		writeErrorEmpty(obj, name);
	}
	else{//campo non vuoto
		if(!validatePhraseShort(obj.value)){
			obj.className="error";
			writeError(obj, name, "sono ammesse solo lettere, numeri e i seguenti simboli: .,;:-");
		}
		else{
			obj.className="";
			removeErrorChildToANode(obj);
		}
	}
	} 
	
}

function checkNumberCard(){
    var numbercard_user = document.getElementById("numbercard_user");
	if(!notEmpty(numbercard_user.value)){//se il campo è vuoto
		numbercard_user.className="error";
		writeErrorEmpty(numbercard_user, "carta di credito");
	}
	else{//campo non vuoto
		if(!validateCardNumber(numbercard_user.value)){
			numbercard_user.className="error";
			writeError(numbercard_user, "carta di credito","numero carta di credito non valido, inserire tutto attaccato");
		}
		else{
			numbercard_user.className="";
			removeErrorChildToANode(numbercard_user);
		}
	}
}

function checkPhoneNumber(){
    var phone_user = document.getElementById("phone_user");
	if(!notEmpty(phone_user.value)){//se il campo è vuoto
		return;
	}
	else{//campo non vuoto
		if(!validatePhoneNumber(phone_user.value)){
			phone_user.className="error";
			writeError(phone_user, "numero di telefono", "non è un numbero valido, inserire tutto attaccato");
		}
		else{
			phone_user.className="";
			removeErrorChildToANode(phone_user);
		}
	}
}
/* funzione utile al controllo del codice fiscale*/
function ConvertToUpperCase(obj){
	obj.value = obj.value.toUpperCase();
}

function checkCodiceFiscale(){
    var codicefiscale_user = document.getElementById("codicefiscale_user");
	ConvertToUpperCase(codicefiscale_user);
	if(!notEmpty(codicefiscale_user.value)){//se il campo è vuoto
		codicefiscale_user.className="error";
		writeErrorEmpty(codicefiscale_user,"codice fiscale");
	}
	else{//campo non vuoto
		if(!validateCodiceFiscale(codicefiscale_user.value)){
			codicefiscale_user.className="error";
			writeError(codicefiscale_user,"codice fiscale","non è un codice fiscale valido");
		}
		else{
			codicefiscale_user.className="";
			removeErrorChildToANode(codicefiscale_user);
		}
	}
}

function checkDate(obj, name){ 
	if(!notEmpty(obj.value)){//se il campo è vuoto
		obj.className="error";
		writeErrorEmpty(obj, name);
	}
	else{//campo non vuoto
		if(!validateDate(obj.value)){
			obj.className="error";
			writeError(obj, name, "la data non è valida e deve essere scritta in questo formato: GG-MM-AAAA");
		}
		else{
			obj.className="";
			removeErrorChildToANode(obj);
		}
	}
}
/****************************************************************************************/
/*
function check_giorno(obj, name){
	if(!notEmpty(obj.value)){//se il campo è vuoto
		obj.className="error";
		writeErrorEmpty(obj, name);
	}else{
		var rePNum = /[0-9]+/;
		var number = obj.value;
		if(rePNum.test(number)){   //il numero è intero
  			if(number > "0" && number<= "31"){
  				obj.className="";
				removeErrorChildToANode(obj);
  			}else{
  			obj.className="error";
			writeError(obj, name, "inserire un giorno valido");
  		}
  		}else{
  			obj.className="error";
			writeError(obj, name, "sono ammessi solo numeri");
	}
}
}*/
/*
function check_mese(obj, name){
	if(!notEmpty(obj.value)){//se il campo è vuoto
		obj.className="error";
		writeErrorEmpty(obj, name);
	}else{
		var rePNum = /[0-9]+/;
		var number = obj.value;
		if(rePNum.test(number)){   //il numero è intero
  			if(number > "0" && number<= "12"){
  				obj.className="";
				removeErrorChildToANode(obj);
  			}else{
  			obj.className="error";
			writeError(obj, name, "inserire un mese valido");
  		}
  		}else{
  			obj.className="error";
			writeError(obj, name, "sono ammessi solo numeri");
	}
}
}*//*
function check_anno(obj, name){
	var currentTime = new Date()
	var year = currentTime.getFullYear();
	if(!notEmpty(obj.value)){//se il campo è vuoto
		obj.className="error";
		writeErrorEmpty(obj, name);
	}else{
		var rePNum = /[0-9]+/;
		var number = obj.value;
		if(rePNum.test(number)){   //il numero è intero
  			if(number > "1900" && number< year){
  				obj.className="";
				removeErrorChildToANode(obj);
  			}else{
  			obj.className="error";
			writeError(obj, name, "inserire un anno valido");
  		}
  		}else{
  			obj.className="error";
			writeError(obj, name, "sono ammessi solo numeri");
	}
}
}*/


/*
function validateMyForm(cond)
{
  if(cond===true){
		return true;
	}
	else{ 
		return false;
  }
}*/
/************************** funzioni di stampa  ***********************************/

function writeError(id, field, message, language){//accetta in ingresso una parola di lingua differente dall'italiano, ma deve essere solo field e di lingua language, campo language opzionale
	if(document.getElementById("error"+id.id))document.getElementById("error"+id.id).parentElement.removeChild(document.getElementById("error"+id.id));
	var error = document.createElement("span");
    error.setAttribute("class", "erroreForm");
	error.id="error"+id.id;
	//error.className="error";
	if(language!=null){
		var textError0 = document.createTextNode("  Campo ");
		var spanError = document.createElement("span");
		var textError1 = document.createTextNode(" errato: " + message);
		spanError.lang=language;
		spanError.appendChild(document.createTextNode(field));
		error.appendChild(textError0); error.appendChild(spanError); error.appendChild(textError1);
	}
	else{
		var textError = document.createTextNode("  Campo " + field + " errato: " + message);
		error.appendChild(textError);
	}
	id.parentElement.insertBefore(error, id);
}

//*********************************************************************************************************//
                        //  DEVO ELIMINARE IL FIGLIO SPAN SE PRESENTE ZIO CAN
/*function writeErrorEmpty(id, field){
	window.alert(id.id);
		if(document.getElementById("error"+id.id)){window.alert(id.id); document.getElementById("error"+id.id).parentElement.removeChild(document.getElementById("error"+id.id));}

	/*window.alert(id.id);
	var padre = document.getElementById(id.id);		//qui ho il padre dell'errore che andrò a salvare
	var descendants = padre.getElementsByTagName("span");
		window.alert(descendants);
	if(descendants) {window.alert("sto per eliminare il nodo"); parentElement.removeChild(descendants);}
var padre = document.getElementById(id.id);		//qui ho il padre dell'errore che andrò a salvare
	var error = document.createElement("span");
	error.setAttribute("class", "erroreForm");
	error.appendChild( document.createTextNode("Errore, campo vuoto") );
	padre.insertBefore(error, id);

}*/
//*********************************************************************************************************//


function writeErrorEmpty(id, field, language){
	
	if(document.getElementById("error"+id.id))document.getElementById("error"+id.id).parentElement.removeChild(document.getElementById("error"+id.id));
	var error = document.createElement("span");
	error.className="error";
	error.setAttribute("class", "erroreForm");
	error.id="error"+id.id;
	if(language!=null){
		var textError0 = document.createTextNode(" Campo ");
		var spanError = document.createElement("span");
		var textError1 = document.createTextNode(" vuoto: campo obbligatorio");
		spanError.lang=language;
		spanError.appendChild(document.createTextNode(field));
		error.appendChild(textError0); 
		error.appendChild(spanError); 
		error.appendChild(textError1);
	}
	else{
		var textError = document.createTextNode("Campo " + field + " vuoto: campo obbligatorio");
		error.appendChild(textError);
	}

		 id.parentElement.insertBefore(error, id);
}
/*
function writeErrorEmpty(id, field, language){
	if(document.getElementById("error"+id.id))document.getElementById("error"+id.id).parentElement.removeChild(document.getElementById("error"+id.id));
	var error = document.createElement("p");
	error.className="error";
	error.id="error"+id.id;
	if(language!=null){
		var textError0 = document.createTextNode("Campo ");
		var spanError = document.createElement("span");
		var textError1 = document.createTextNode(" vuoto: campo obbligatorio");
		spanError.lang=language;
		spanError.appendChild(document.createTextNode(field));
		error.appendChild(textError0); error.appendChild(spanError); error.appendChild(textError1);
	}
	else{
		var textError = document.createTextNode("Campo " + field + " vuoto: campo obbligatorio");
		error.appendChild(textError);
	}
	id.parentElement.insertBefore(error, id);
}*/

function removeChildToNode(child){
	child.parentNode.removeChild(child);
}
function removeErrorChildToANode(child){
	if(document.getElementById("error"+child.id))document.getElementById("error"+child.id).parentElement.removeChild(document.getElementById("error"+child.id));
}





/*
function validateRegistration(){
	var email_user = document.getElementById("email_user").value;
	var pwd0 = document.getElementById("password_user").value;
	var pwd1 = document.getElementById("password_user_repeat").value;
	var name_user = document.getElementById("name_user").value;
	var surname_user = document.getElementById("surname_user").value;
	var numbercard_user = document.getElementById("numbercard_user").value;
	var deadlinecard_user = document.getElementById("deadlinecard_user").value;
	var city_user = document.getElementById("city_user").value;
	var job_user = document.getElementById("job_user").value;
	var address_user = document.getElementById("address_user").value;
	var phone_user = document.getElementById("phone_user").value;
	var datebirth_user = document.getElementById("datebirth_user").value;
	var codicefiscale_user = document.getElementById("codicefiscale_user").value; //es. PPPPLT00A01E283H o PPPPLT80R10M082K
	var checked = false;
	if(validateEmail(email_user) && validatePassword(pwd0) && validatePasswordRepeat(pwd0, pwd1) && validateWord(name_user) && validateWord(surname_user) && validateWord(city_user) && validatePhrase(address_user) && validatePhrase(job_user) && validateCardNumber(numbercard_user) && validateDate(deadlinecard_user) && validateDate(datebirth_user) && validateCodiceFiscale(codicefiscale_user)) 
		checked = true;
	return validateMyForm(checked);
}
*/




/*function validateRegistrationFormUno(){
	aller("sentinella");
	var email = document.getElementById("email_user").value;
	var pwd0 = document.getElementById("password").value;
	var pwd1 = document.getElementById("password_repeat").value;

	var checked = false;
	if(validateEmail(email) && validatePassword(pwd0) && validatePasswordRepeat(pwd0, pwd1) && validateWord(name_user) && validateWord(surname_user) && validateWord(city_user) && validatePhrase(address_user) && validatePhrase(job_user) && validateCardNumber(numbercard_user) && validateDate(deadlinecard_user) && validateDate(datebirth_user) && validateCodiceFiscale(codicefiscale_user)) 
	checked = true;
	return validateMyForm(checked);
}*/