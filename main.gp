nb = 512;
nbm = 12;
mod = 1<<nbm;
mask = 2*(4^(nbm/2)-1)/(4-1);
n = read("input.txt");
chiffre(m) = [m^2%n,kronecker(m,n),m%2];
dechiffre(c) = read("dec")(c);
m = random(1<<500)<<nb+mask;
if(dechiffre(chiffre(m)) != m,error("problème d'énoncé à signaler"));



test_Miller_Rabin (n, x)={
	if(gcd(n,x)!=1, print(x," n’est pas premier avec ", n); return());
	my(i,m,k);
	m=n-1;
	k=0;
	while(m%2==0, m=m/2;k=k+1);
	\\Ici,n-1= 2^k*m
	if(Mod(x,n)^m==1, print(n," PEUT etre premier" ) ;return(true) ) ;
	for( i=0,k-1,if(Mod(x,n)^(m*2^i)==-1,print(n," PEUT etre premier",i," ",m) ;return(true)) );
	print(n," n’est pas premier");
	return false;
};

/* ****************************************************************************** */
/* ******************************* Explications : ******************************* */
/* ****************************************************************************** */

/* On a n = pq, et p=q=3[4]
 * Et on  doit trouver p et q.
 
 * Rappel :
   * c = m^2 mod n
   * m_p = c^((p+1)/4) mod p
   * m_q = c^((q+1)/4) mod q

   * ±m_p+pZ et ±m_q+qZ sont les deux racines carrées de,
     respectivement, c+pZ dans pZ et c+qZ dans qZ.
     
 * Nota Bene : cette méthode fonctionne seulement parce que p et q sont tous les deux congrus à 3 mod 4
 
 
 *On a accès à la fonction de chiffrement et de déchiffrement :
   on peut essayer une attaque à chiffrés choisis !
 * Si l’on a accès au déchiffrement, pour tout message m,
   le déchiffrement de (m^2,−(m/n),m  mod  2) est un m' 
   tel que m'=± m[p] et m'=± m [ q], 
   de sorte que pgcd⁡(m−m′,n) vaut p ou q.
 */
 

\\m_b = m' = dechiffre([m^2, -(m/n), m mod 2]);
m_b = vector(3);
m_b[1] = (m^2)%n;
m_b[2]= -kronecker(m,n);
m_b[3]= m%2;

m_b = dechiffre(m_b);


\\ On devrait avoir
\\ m_b = ±m[p]
\\ m_b = ±m[q]
\\ donc pgcd(m - m_b, n) vaut soit p soit q


/* Remarque :
 * En étant déchiffré, m_b peut être nul (à cause des sécurités lors du déchiffrement).
 * On va donc répéter l'opération, avec des chiffrés différents,
 * tant que m_b est nul (ou égal à m) :
*/


/* Nota Bene : après avoir fait tourner la boucle, on trouve que cela fonctionne ici,
 * avec une certaine valeur de m.
 * Pour éviter trop de temps de calcul, ici, on 'force' l'aléatoire, ce qui évitera de rentrer dans la boucle ;
 * mais pour une autre valeur, on rentrera dans la boucle, jusqu'à avoir de bonnes valeurs.
 * Ce qui prend simplement un peu plus de temps, mais est tout à fait efficace...
 */

m=29857323317201658134325885754637313123058590319595533733351839903745743765433917000580576295113059588791994962003601850921218257041112674504702905649993304465401051458241447968214580628958934706235888786670492429678850321738710919739623005600983944747250098662133208671583433600708598072107309472780651178;


m_b = vector(3);
m_b[1] = (m^2)%n;
m_b[2]= - kronecker(m,n);
m_b[3]= m%2;

m_b = dechiffre(m_b);


while(m_b==0 || m_b==m, {m = random(1<<500)<<nb+mask;m_b = vector(3); m_b[1] = (m^2)%n; m_b[2]= - kronecker(m,n); m_b[3]= m%2; m_b = dechiffre(m_b);});


\\ Et là, on a bien
\\ m_b = ±m[p]
\\ m_b = ±m[q]
\\ donc pgcd(m - m_b, n) vaut soit p soit q

d = gcd(m - m_b, n);

p = min(d, (n/d));

print(p);



