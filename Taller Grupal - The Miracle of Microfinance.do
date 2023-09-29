/* 
Universidad de los Andes 
Facultad de Economia 
Maestria en Economia Aplicadas 
MECA 4402 - Evaluación de Impacto 2023-2
Trabajo en Grupo - The Miracle of Microfinance?
Maria Camila Gomez - Juan Camilo Sanchez - Juan Sebastian Osorno 
*/

clear all
use "C:\Users\juano\Documents\Libros y Papers Asperos\Economia Aplicada\2023 - II\Evaluacion de Impacto\Taller\data_taller.dta" 

set seed 201814546
gen rand = runiform(0,1)
keep if rand <0.95

* 1)
** Regresion Lineal Simple 
***Estime el efecto de tener un crédito en alguna IMF en Seguimiento 1 (anymfi_1) sobre Activos (bizassets_1), Inversión en los últimos 12 meses (bizinvestment_1) y Ganancias (bizprofit_1). Interprete los resultados

reg bizassets_1 anymfi_1
eststo Sobre_activos

reg bizinvestment_1 anymfi_1 
eststo Sobre_Inversion_12_meses

reg bizprofit_1 anymfi_1
eststo Sobre_Ganancias

outreg2 [Sobre_activos Sobre_Inversion_12_meses Sobre_Ganancias] using Tabla_reg_lineal.doc, replace see beta

*3)
* Regresion Lineal con Controles y Efectos Fijos 
*** estime las mismas regresiones del Punto 1 pero incluyendo los controles y efectos fijos que usted considere relevantes para reducir los sesgos potenciales. Argumente por qué piensa que la adición de estos efectos fijos y/o variables de control pueden reducir el sesgo.

* Controles 
global CONTROLES  total_exp_mo_pc_1 durables_exp_mo_pc_1 temptation_exp_mo_pc_1 

** Regresion con Controles y Efectos Fijos 

areg bizassets_1 anymfi_1 $CONTROLES, absorb(areaid),cluster(areaid)

areg bizinvestment_1 anymfi_1 $CONTROLES, absorb(areaid) cluster(areaid)

areg bizprofit_1 anymfi_1 $CONTROLES, absorb(areaid) cluster(areaid)

* Variable Instrumental y Efectos aleatorios – Replicación, interpretación y extensión

*en el paper se usan controles distintos 

global Xa area_pop_base area_business_total_base area_exp_pc_mean_base area_literate_head_base area_literate_base 


*** 6.) Replique el cuadro 2 panel A, columnas 1 a 5 para mostrar el efecto de las microfinanzas en el acceso a préstamos. Explique la intuición detrás de los resultados: más específicamente, ¿la expansión de las sucursales de Spandana resultó en un aumento significativo en el acceso al microcrédito? ¿Parece provenir, parcial o totalmente, del desplazamiento del microcrédito de otros bancos? ¿O por el desplazamiento del crédito informal?


** sugieren usar como control (area_debt_total_base) pero veo que no afecta de a mucho 

 * Acceso al Credito 
 
global P6a spandana_1 othermfi_1 anymfi_1 anybank_1 anyinformal_1 

mvreg $P6a = treatment $Xa [aweight=w1] 

* Montos de los Prestamos

global P6b spandana_amt_1 othermfi_amt_1 anymfi_amt_1 bank_amt_1 informal_amt_1 

mvreg $P6b = treatment $Xa area_debt_total_base [aweight=w1]


*7) Replique el cuadro 3, paneles A y B, columnas 1, 2 y 4. Interprete brevemente los resultados: ¿La expansión de las sucursales aumentó significativamente los activos, las inversiones y las ganancias de las empresas en el corto plazo (línea final 1) y en el mediano plazo (línea final 2)? Responda por separado para ambas líneas finales. Cuando haya efectos significativos, conviértalo en un efecto del tratamiento como una proporción de la media de control y analice su tamaño relativo.

*Panel A

global P7a bizassets_1 bizinvestment_1 bizprofit_1

mvreg $P7a = treatment $Xa [aweight=w1] 


*Panel B

global P7b bizassets_2 bizinvestment_2 bizprofit_2

mvreg $P7b = treatment $Xa [aweight=w2] 
outreg2 using "punto7.xls", excel replace ///
addtext(Efecto de las microfinanzas en los activos) ///
keep(treatment) stats(coef) bdec(3) pdec(4)

*8.) Replique las columnas 1, 2, 3 y 7 del Cuadro 6 Panel A para mostrar el efecto de las microfinanzas en el consumo. Explique la intuición detrás de los resultados: en términos generales, ¿el tratamiento afectó significativamente el consumo total? ¿Afectó la composición del consumo? ¿De qué manera y cómo se puede explicar por la presencia de las IMF?

global P8 total_exp_mo_pc_1 durables_exp_mo_pc_1 nondurable_exp_mo_pc_1 temptation_exp_mo_pc_1

mvreg $P8 = treatment $Xa [aweight=w1]

outreg2 using "punto8.xls", excel replace ///
addtext(Efecto de las microfinanzas en el consumo) ///
keep(treatment) stats(coef) bdec(3) pdec(4)
	
	

* 9. Replique el cuadro 7 panel A, columnas 1 a 7 para obtener los efectos sociales de las microfinanzas. Explique la intuición detrás de los resultados y la conclusión general.

global P9 girl515_school_1 boy515_school_1 girl515_workhrs_pc_1 boy515_workhrs_pc_1 girl1620_school_1 boy1620_school_1 women_emp_index_1

mvreg $P9 = treatment $Xa [aweight=w1]


*11) Tome las estimaciones ITT de beneficios de la tabla 3, columna 4 (beneficios), Panel B, línea final 2. ¿Cuál es el intervalo de confianza del 95% de este coeficiente? Exprese estos valores en porcentaje (%) de la media de control (penúltima línea de la tabla). Interprete en una oración este intervalo de confianza (usando el porcentaje de medias de control). Teniendo esto en cuenta, ¿sostendría usted que los resultados nos permiten rechazar la hipótesis que la presencia de la IMF haya tenido algún impacto económicamente significativo en las ganancias del trabajo por cuenta propia?

* Estimacion de ITT de beneficios en el segundo periodo 

reg bizprofit_2 treatment $Xa [aweight=w2], cluster(areaid)

* Intervalo de Confianza
gen ICp = 1139.893 - 428.442 
gen ICn = 428.442 + 283.0086 

sum ICp
sum ICn

* Media de Control 
sum bizprofit_2 if treatment==0

gen MC = 1015.815

* Porcentaje de la Media de Control
gen PMC= (ICp/MC)*100

sum PMC 

*Ahora desea estimar el impacto de recibir efectivamente un préstamo de microcrédito sobre el beneficio empresarial (bizassets_1) y el consumo mensual total (total_exp_mo_pc_1). 

*Para hacer esto, tome anymfi_1 como la variable de tratamiento efectivo, que toma el valor de uno si el hogar recibió algún préstamo de cualquier IMF al final de la línea 1, y cero en caso contrario. Tome como instrumento el hecho de que la ubicación de los bancos fue aleatoria. En particular, utilice como instrumento la presencia aleatoria de Spandana en la línea final 1 (tratamiento). Responda las siguientes preguntas teniendo en cuenta estas definiciones y variables.

* regresion sin IV con efectos fijos de area 

areg bizassets_1 anymfi_1, absorb(areaid) cluster (areaid)

areg total_exp_mo_pc_1 anymfi_1, absorb(areaid) cluster (areaid)

* Regresion instrumentando por Spandana 

ivreg2 bizassets_1 (anymfi_1=spandana_1) $Xa, cluster(areaid)

ivreg2 total_exp_mo_pc_1  (anymfi_1=spandana_1) $Xa, cluster(areaid)

*12) ¿Cuáles son los supuestos necesarios para que el estimador IV sea válido en este contexto y especificación? ¿Podría mencionar al menos una razón por la cual es posible que no se cumpla?



*13) Utilizando la especificación de IV descrita anteriormente, ¿cuál es la tasa de cumplimiento en el período 1? (Pista: puede encontrarla directamente en la tabla 2, que es equivalente a la primera etapa de la IV) ¿Parece alto o bajo? Interprete


reg spandana_1 treatment $Xa area_debt_total_base [aweight=w1]
 
reg anymfi_1 treatment $Xa area_debt_total_base  [aweight=w1] 

*14) Tanto para las ganancias comerciales como para el consumo mensual total, utilice la especificación de IV descrita anteriormente para estimar el efecto de tratamiento promedio local (LATE) de la obtención de un préstamo (instrumentado por la presencia aleatoria de Spandana) y preséntelo con su error estándar, intervalos de confianza y medias de control. Interprete en una oración los intervalos de confianza de cada una de las variables (también como porcentaje de su media de control).

*Ganancias

ivreg2 bizprofit_1 (anymfi_1=spandana_1) $Xa area_debt_total_base, cluster(areaid)


* Intervalo de Confianza - Ganancias
gen ICp2 =  1259.106 - 594.1074 
gen ICn2 = 594.1074 +  70.89145  

sum ICp2  
sum ICn2

* Media de Control - Ganancias
sum bizprofit_1 if treatment==0

gen MC2 =  747.2836 

* Porcentaje de la Media de Control - Ganancias
gen PMC2= (ICp2/MC2)*100

sum PMC2 

* Consumo Mensual

ivreg2 total_exp_mo_pc_1 (anymfi_1=spandana_1) $Xa area_debt_total_base, cluster(areaid)

* Intervalo de Confianza - Consumo
gen ICp3 = 58.55711 + 17.7706 
gen ICn3 = 94.09832 - 17.7706   

sum ICp3  
sum ICn3

* Media de Control - Consumo 

sum total_exp_mo_pc_1 if treatment==0

gen MC3 =  1423.675  

* Porcentaje de la Media de Control - Ganancias
gen PMC3= (ICp3/MC3)*100

sum PMC3 


*Punto 17: Verificar selección:
*Primero mediante una regresión simple vemos que el índice tiene un coeficiente significativo y positivo sobre el tratamiento
reg treatment indice $area_controles, cluster(areaid)

*También mediante un diagrama de dispersión podemos observar el corte a partir del 60
scatter treatment indice

*Punto 18: efecto del tratamiento sobre bizassets_1, bizinvestment_1 y biz_profit1

*Generamos tratamiento
gen X_T = indice*treatment

est clear
foreach var in bizassets_1 bizinvestment_1 bizprofit_1  {
	reg `var' treatment indice $area_controles if inrange(indice, 50, 70) [pweight=w1], cluster(areaid)
	
		est store `var'
}
estout * using "punto18.txt", drop($area_controles _cons) title("Regresiones discontinuas")


/*Punto 19: Prueba para evaluar el supuesto de identificación (pueden por ejemplo averiguar la ausencia de agrupamiento (o bunching) alrededor del corte, o averiguar que los controles predeterminados no parecen afectados por el tratamiento con la especificación de RD */


**comprobación de supuestos**

*Asignación-manipulación (variable de asignación: indice)

histogram indice, xline(60) bins(200)
kdensity indice, xline(60)

*Se observa un salto en el umbral


*Punto 20 prueba de robustez. Puede por ejemplo ajustar la forma funcional o cambiar el ancho de banda.

*Usamos polinomio de índice y tratamiento

est clear
foreach var in bizassets_1 bizinvestment_1 bizprofit_1  {
	reg `var' treatment indice X_T $area_controles if inrange(indice, 50, 70) [pweight=w1], cluster(areaid)
	
		est store `var'
}


*Al usarlo, los resultados en bizassets_1 se vuelven significativos

*Ahora ajustando el umbral
est clear
foreach var in bizassets_1 bizinvestment_1 bizprofit_1  {
	reg `var' treatment indice X_T $area_controles if inrange(indice, 55, 65) [pweight=w1], cluster(areaid)
	
		est store `var'
}


*Los signos cambian, por lo que la intuición puede no ser correcta


