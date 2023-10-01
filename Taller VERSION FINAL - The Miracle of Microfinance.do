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

ssc install outreg2

* 1)
** Regresion Lineal Simple 
***Estime el efecto de tener un crédito en alguna IMF en Seguimiento 1 (anymfi_1) sobre Activos (bizassets_1), Inversión en los últimos 12 meses (bizinvestment_1) y Ganancias (bizprofit_1). Interprete los resultados

reg bizassets_1 anymfi_1
est store Sobre_activos

reg bizinvestment_1 anymfi_1 
est store Sobre_Inversion

reg bizprofit_1 anymfi_1
est store Sobre_Ganancias

outreg2 [Sobre_activos Sobre_Inversion Sobre_Ganancias] using Tabla_reg_lineal.doc

*3)
* Regresion Lineal con Controles y Efectos Fijos 
*** estime las mismas regresiones del Punto 1 pero incluyendo los controles y efectos fijos que usted considere relevantes para reducir los sesgos potenciales. Argumente por qué piensa que la adición de estos efectos fijos y/o variables de control pueden reducir el sesgo.

* Controles 
global CONTROLES  total_exp_mo_pc_1 durables_exp_mo_pc_1 temptation_exp_mo_pc_1 

** Regresion con Controles y Efectos Fijos 

areg bizassets_1 anymfi_1 $CONTROLES, absorb(areaid) cluster(areaid) 
est store Sobre_activos_ControlesyEF

areg bizinvestment_1 anymfi_1 $CONTROLES, absorb(areaid) cluster(areaid) 
est store Sobre_InversionControlesyEF

areg bizprofit_1 anymfi_1 $CONTROLES, absorb(areaid) cluster(areaid)
est store Sobre_GananciasControlesyEF

outreg2 [Sobre_activos_ControlesyEF Sobre_InversionControlesyEF Sobre_GananciasControlesyEF] using Tabla_reg_controles.doc

* Variable Instrumental y Efectos aleatorios – Replicación, interpretación y extensión

*en el paper se usan controles distintos 

global Xa area_pop_base area_business_total_base area_exp_pc_mean_base area_literate_head_base area_literate_base 


*** 6.) Replique el cuadro 2 panel A, columnas 1 a 5 para mostrar el efecto de las microfinanzas en el acceso a préstamos. Explique la intuición detrás de los resultados: más específicamente, ¿la expansión de las sucursales de Spandana resultó en un aumento significativo en el acceso al microcrédito? ¿Parece provenir, parcial o totalmente, del desplazamiento del microcrédito de otros bancos? ¿O por el desplazamiento del crédito informal?


** sugieren usar como control (area_debt_total_base) pero veo que no afecta de a mucho 

 * Acceso al Credito 
 
reg spandana_1 treatment $Xa area_debt_total_base [aweight=w1], cluster (areaid)
est store SpandanaAcc1

reg othermfi_1 treatment $Xa area_debt_total_base [aweight=w1], cluster (areaid)
est store OtraMFIAcc1

reg anymfi_1 treatment $Xa area_debt_total_base [aweight=w1], cluster (areaid)
est store MFIAcc1 

reg anybank_1 treatment $Xa area_debt_total_base [aweight=w1], cluster (areaid)
est store BancoAcc1

reg anyinformal_1 treatment $Xa area_debt_total_base [aweight=w1], cluster (areaid)
est store InformalAcc1

outreg2 [SpandanaAcc1 OtraMFIAcc1 MFIAcc1 BancoAcc1 InformalAcc1] using Tabla_reg_Punto6.doc

* Montos de los Prestamos

reg spandana_amt_1 treatment $Xa area_debt_total_base [aweight=w1], cluster (areaid)
est store SpandanaMonto1

reg othermfi_amt_1 treatment $Xa area_debt_total_base [aweight=w1], cluster (areaid)
est store OtraMFIMonto1

reg anymfi_amt_1 treatment $Xa area_debt_total_base [aweight=w1], cluster (areaid)
est store MFIMonto1 

reg bank_amt_1 treatment $Xa area_debt_total_base [aweight=w1], cluster (areaid)
est store BancoMonto1

reg informal_amt_1 treatment $Xa area_debt_total_base [aweight=w1], cluster (areaid)
est store InformalMonto1

outreg2 [SpandanaMonto1 OtraMFIMonto1 MFIMonto1 BancoMonto1 InformalMonto1 ] using Tabla_reg_Punto6b.doc


*7) Replique el cuadro 3, paneles A y B, columnas 1, 2 y 4. Interprete brevemente los resultados: ¿La expansión de las sucursales aumentó significativamente los activos, las inversiones y las ganancias de las empresas en el corto plazo (línea final 1) y en el mediano plazo (línea final 2)? Responda por separado para ambas líneas finales. Cuando haya efectos significativos, conviértalo en un efecto del tratamiento como una proporción de la media de control y analice su tamaño relativo.

*Panel A

reg bizassets_1 treatment $Xa area_debt_total_base [aweight=w1], cluster (areaid)
est store Activos1

reg bizinvestment_1 treatment $Xa area_debt_total_base [aweight=w1], cluster (areaid)
est store Inversion1

reg bizprofit_1 treatment $Xa area_debt_total_base [aweight=w1], cluster (areaid)
est store Ganancias1

*Panel B

reg bizassets_2 treatment $Xa [aweight=w2], cluster (areaid)
est store Activos2

reg bizinvestment_2 treatment $Xa [aweight=w2], cluster (areaid)
est store Inversion2

reg bizprofit_2 treatment $Xa [aweight=w2], cluster (areaid)
est store Ganancias2

outreg2 [Activos1 Inversion1 Ganancias1 Activos2 Inversion2 Ganancias2] using Tabla_reg_Punto7.doc

*8.) Replique las columnas 1, 2, 3 y 7 del Cuadro 6 Panel A para mostrar el efecto de las microfinanzas en el consumo. Explique la intuición detrás de los resultados: en términos generales, ¿el tratamiento afectó significativamente el consumo total? ¿Afectó la composición del consumo? ¿De qué manera y cómo se puede explicar por la presencia de las IMF?

reg total_exp_mo_pc_1 treatment $Xa [aweight=w1], cluster (areaid)
est store GastosTotales1

reg durables_exp_mo_pc_1 treatment $Xa [aweight=w1], cluster (areaid)
est store GastosDurables1

reg nondurable_exp_mo_pc_1 treatment $Xa [aweight=w1], cluster (areaid)
est store GastosNoDurables1

reg temptation_exp_mo_pc_1 treatment $Xa [aweight=w1], cluster (areaid)
est store GastosTentacion1

outreg2 [GastosTotales1 GastosDurables1 GastosNoDurables1 GastosTentacion1] using Tabla_reg_Punto8.doc, drop ($Xa _cons) title("Efectos de las microfinanzas en el consumo")


* 9. Replique el cuadro 7 panel A, columnas 1 a 7 para obtener los efectos sociales de las microfinanzas. Explique la intuición detrás de los resultados y la conclusión general.

global P9 girl515_school_1 boy515_school_1 girl515_workhrs_pc_1 boy515_workhrs_pc_1 girl1620_school_1 boy1620_school_1 women_emp_index_1

reg girl515_school_1 treatment $Xa [aweight=w1], cluster (areaid)
est store Ninas_5a15_Colegio

reg  boy515_school_1 treatment $Xa [aweight=w1], cluster (areaid)
est store Ninos_5a15_Colegio

reg girl515_workhrs_pc_1 treatment $Xa [aweight=w1], cluster (areaid)
est store Ninas_5a15_HrsTrbj

reg boy515_workhrs_pc_1 treatment $Xa [aweight=w1], cluster (areaid)
est store Ninos_5a15_HrsTrbj

reg girl1620_school_1 treatment $Xa [aweight=w1], cluster (areaid)
est store Ninas_16a20_Colegio

reg boy1620_school_1 treatment $Xa [aweight=w1], cluster (areaid)
est store Ninos_16a20_Colegio

reg women_emp_index_1 treatment $Xa [aweight=w1], cluster (areaid)
est store IndiceEmpFem

outreg2 [Ninas_5a15_Colegio Ninos_5a15_Colegio Ninas_5a15_HrsTrbj Ninos_5a15_HrsTrbj Ninas_16a20_Colegio Ninos_16a20_Colegio IndiceEmpFem] using Tabla_reg_Punto9.doc, drop ($Xa _cons) title("Efectos sociales en las microfinanzas")


*11) Tome las estimaciones ITT de beneficios de la tabla 3, columna 4 (beneficios), Panel B, línea final 2. ¿Cuál es el intervalo de confianza del 95% de este coeficiente? Exprese estos valores en porcentaje (%) de la media de control (penúltima línea de la tabla). Interprete en una oración este intervalo de confianza (usando el porcentaje de medias de control). Teniendo esto en cuenta, ¿sostendría usted que los resultados nos permiten rechazar la hipótesis que la presencia de la IMF haya tenido algún impacto económicamente significativo en las ganancias del trabajo por cuenta propia?

* Estimacion de ITT de beneficios en el segundo periodo 

reg bizprofit_2 treatment $Xa [aweight=w2], cluster(areaid)
est store RegresionP11

* Intervalo de Confianza
gen ICp = 1139.893 - 428.442 
gen ICn = 428.442 + 283.0086 
est store IntervaloDeConfianza
sum ICp

* Media de Control 
sum bizprofit_2 if treatment==0
gen MC = 1015.815
est store MediaDeControl

* Porcentaje de la Media de Control
gen PMC= (ICp/MC)*100
sum PMC 
est store PctgDeMediaDeControl

outreg2 [RegresionP11] using Tabla_reg_Punto11.doc

*Ahora desea estimar el impacto de recibir efectivamente un préstamo de microcrédito sobre el beneficio empresarial (bizassets_1) y el consumo mensual total (total_exp_mo_pc_1). 

*Para hacer esto, tome anymfi_1 como la variable de tratamiento efectivo, que toma el valor de uno si el hogar recibió algún préstamo de cualquier IMF al final de la línea 1, y cero en caso contrario. Tome como instrumento el hecho de que la ubicación de los bancos fue aleatoria. En particular, utilice como instrumento la presencia aleatoria de Spandana en la línea final 1 (tratamiento). Responda las siguientes preguntas teniendo en cuenta estas definiciones y variables.

* regresion sin IV con efectos fijos de area 

areg bizassets_1 anymfi_1, absorb(areaid) cluster (areaid)

areg total_exp_mo_pc_1 anymfi_1, absorb(areaid) cluster (areaid)

* Regresion instrumentando por Spandana 

ivreg2 bizassets_1 (anymfi_1=treatment) $Xa, cluster(areaid)
est store ActivosIV_1
ivreg2 total_exp_mo_pc_1  (anymfi_1=treatment) $Xa, cluster(areaid)
est store ConsumoIV_1

outreg2 [ActivosIV_1 ConsumoIV_1] using Tabla_reg_Punto11.doc

*12) ¿Cuáles son los supuestos necesarios para que el estimador IV sea válido en este contexto y especificación? ¿Podría mencionar al menos una razón por la cual es posible que no se cumpla?



*13) Utilizando la especificación de IV descrita anteriormente, ¿cuál es la tasa de cumplimiento en el período 1? (Pista: puede encontrarla directamente en la tabla 2, que es equivalente a la primera etapa de la IV) ¿Parece alto o bajo? Interprete

reg anymfi_1 treatment $Xa area_debt_total_base [aweight=w1] 
est store Primera_Etapa_b

outreg2 [Primera_Etapa_a Primera_Etapa_b] using Tabla_reg_Punto13.doc

*14) Tanto para las ganancias comerciales como para el consumo mensual total, utilice la especificación de IV descrita anteriormente para estimar el efecto de tratamiento promedio local (LATE) de la obtención de un préstamo (instrumentado por la presencia aleatoria de Spandana) y preséntelo con su error estándar, intervalos de confianza y medias de control. Interprete en una oración los intervalos de confianza de cada una de las variables (también como porcentaje de su media de control).

*Ganancias

ivreg2 bizprofit_1 (anymfi_1=treatment) $Xa area_debt_total_base, cluster(areaid)
est store GananciasIV_1

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

ivreg2 total_exp_mo_pc_1 (anymfi_1=treatment) $Xa area_debt_total_base, cluster(areaid)
est store ConsumoIV_2

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

outreg2 [GananciasIV_1 ConsumoIV_2] using Tabla_reg_Punto14.doc

*Punto 17: Verificar selección:
*Primero mediante una regresión simple vemos que el índice tiene un coeficiente significativo y positivo sobre el tratamiento

*Creamos global de controles de área (estoy utilizando los que mencionan en el paper)
global area_controles area_pop_base area_business_total_base area_exp_pc_mean_base area_literate_head_base area_literate_base

reg treatment indice $area_controles, cluster(areaid)

*También mediante un diagrama de dispersión podemos observar el corte a partir del 60
scatter treatment indice

*Punto 18: efecto del tratamiento sobre bizassets_1, bizinvestment_1 y biz_profit1

*Generamos interacción de tratamiento
gen X_T = indice*treatment
	
reg bizassets_1 treatment indice $area_controles if inrange(indice, 50, 70) [pweight=w1], cluster(areaid)
est store ActivosRD

reg bizinvestment_1 treatment indice $area_controles if inrange(indice, 50, 70) [pweight=w1], cluster(areaid)
est store InversionRD 

reg bizprofit_1 treatment indice $area_controles if inrange(indice, 50, 70) [pweight=w1], cluster(areaid)
est store GananciasRD

outreg2 [ActivosRD InversionRD GananciasRD] using Tabla_reg_Punto18.doc, drop ($area_controles _cons) title("Regresiones discontinuas")

/*Punto 19: Prueba para evaluar el supuesto de identificación (pueden por ejemplo averiguar la ausencia de agrupamiento (o bunching) alrededor del corte, o averiguar que los controles predeterminados no parecen afectados por el tratamiento con la especificación de RD */



*Asignación-manipulación (variable de asignación: indice)

histogram indice, xline(60) bins(200)
kdensity indice, xline(60)

*Se observa un salto en el umbral

rddensity indice, c(60)
*Valor muy significativo, por lo que se evidencia manipulación

*Punto 20 prueba de robustez. Puede por ejemplo ajustar la forma funcional o cambiar el ancho de banda.

*Usamos polinomio de índice y tratamiento

reg bizassets_1 treatment indice X_T $area_controles if inrange(indice, 50, 70) [pweight=w1], cluster(areaid)
est store ActivosPr

reg bizinvestment_1 treatment indice X_T $area_controles if inrange(indice, 50, 70) [pweight=w1], cluster(areaid)
est store InversionPr

reg bizprofit_1 treatment indice X_T $area_controles if inrange(indice, 50, 70) [pweight=w1], cluster(areaid)
est store GananciasPr

outreg2 [ActivosPr InversionPr GananciasPr] using Tabla_reg_Punto20.doc, drop ($area_controles _cons) title("Pruebas de robustez: usando polinomio")

*Al usarlo, los resultados en bizassets_1 se vuelven significativos

*Ahora ajustando el umbral

reg bizassets_1 treatment indice X_T $area_controles if inrange(indice, 55, 65) [pweight=w1], cluster(areaid)
est store ActivosPr2

reg bizinvestment_1 treatment indice X_T $area_controles if inrange(indice, 55, 65) [pweight=w1], cluster(areaid)
est store InversionPr2

reg bizprofit_1 treatment indice X_T $area_controles if inrange(indice, 55, 65) [pweight=w1], cluster(areaid)
est store GananciasPr2

outreg2 [ActivosPr2 InversionPr2 GananciasPr2] using Tabla_reg_Punto20b.doc, drop ($area_controles _cons) title("Pruebas de robustez: cambio de umbrales (55-65)")

*Los signos cambian, por lo que la intuición puede no ser correcta
