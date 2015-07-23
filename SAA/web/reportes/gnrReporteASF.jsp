<%-- 
    Document   : reporteASF
    Created on : 01-abr-2015, 12:01:13
    Author     : amerikillo
--%>

<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.text.DecimalFormatSymbols"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="conn.*" %>
<!DOCTYPE html>
<%java.text.DateFormat df = new java.text.SimpleDateFormat("yyyyMMddhhmmss"); %>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("dd/MM/yyyy"); %>
<%
    /**
     * Para generar el reporte de ASF
     */
    DecimalFormat formatter = new DecimalFormat("#,###,###");
    DecimalFormat formatter2 = new DecimalFormat("#,###,###.##");
    DecimalFormatSymbols custom = new DecimalFormatSymbols();
    custom.setDecimalSeparator(',');
    formatter.setDecimalFormatSymbols(custom);
    HttpSession sesion = request.getSession();
    String usua = "ISEM";
    ConectionDB con = new ConectionDB();

    /**
     * Generar Excel
     */
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment;filename=\"ReporteASF.xls\"");
%>
<table border="1">
    <thead>
        <tr>
            <td></td> 
            <td>Catálogo</td>
            <td>Clave</td>
            <td>Descripción</td>
            <td>Existencias a la fecha </td>
            <td>Piezas entregadas a la fecha</td>
            <td>CPM Sur</td>
            <td>Meses de Inv (ASF) Sur</td>
            <td>Piezas Solicitadas a la fecha</td>
            <td>CPM Sol</td>
            <td>Meses de Inv (ASF) Sol</td>
            <td>Última Recepción</td>
            <td>Última Entrega</td>
            <td></td>
        </tr>
    </thead>
    <tbody>
        <%                            /**
             *
             *
             */
            int TotalClaves = 1, contado = 1;
            try {
                con.conectar();
                /**
                 * Se buscan todas las claves que estén disponibles en los 2
                 * catálogos
                 *
                 * tb_cat2014 y tb_cat2015 son los catálogos que se han manejado
                 * hasta ahora
                 */
                ResultSet rset = con.consulta("select F_ClaPro, F_CambioPres from tb_medica where (F_ClaPro in (select F_ClaPro from tb_cat2014)) or (F_ClaPro in (select F_ClaPro from tb_cat2015))");
                while (rset.next()) {

                    String F_DesPro = "", catalogo = "2014";
                    double totalClave = 0, remisionadoClave = 0, CPM = 0, CPCM2014 = 0, invMen2014 = 0, solClave = 0, CPMSol = 0, NIMSol = 0;
                    /**
                     * Por default se asina como catalogo 2015
                     */
                    ResultSet rset2 = con.consulta("select F_ClaPro from tb_cat2015 where F_ClaPro = '" + rset.getString("F_ClaPro") + "'");
                    while (rset2.next()) {
                        catalogo = "2015";
                    }
                    /**
                     * Si estaá en la tabla 2014 quiere decir que corresponde a
                     * ambos catálogos
                     */
                    rset2 = con.consulta("select t1.F_ClaPro from tb_cat2015 t1, tb_cat2014 t2 where t1.F_ClaPro = t2.F_ClaPro and t1.F_ClaPro = '" + rset.getString("F_ClaPro") + "'");
                    while (rset2.next()) {
                        catalogo = "2014/2015";
                    }

                    rset2 = con.consulta("select F_DesPro from tb_medica where F_ClaPro = '" + rset.getString("F_ClaPro") + "' ");

                    while (rset2.next()) {
                        F_DesPro = rset2.getString("F_DesPro");
                    }

                    /**
                     * Dias de diferencia con respecto a la primera vez que se
                     * requirió la clave
                     */
                    int difd = 0, difd2 = 0, meses = 0;
                    rset2 = con.consulta("select datediff( now(), F_FecCarg ) as dias from tb_unireq where F_ClaPro='" + rset.getString("F_ClaPro") + "' LIMIT 1;");
                    while (rset2.next()) {
                        difd2 = rset2.getInt(1);
                    }

                    /**
                     * Días de diferencia con respecto a la primera vez que se
                     * ingresó el insumo
                     */
                    rset2 = con.consulta("select datediff( now(), F_FecMov ) as dias from tb_movinv where F_ProMov='" + rset.getString("F_ClaPro") + "' LIMIT 1;");
                    while (rset2.next()) {
                        difd = rset2.getInt(1);
                    }
                    /**
                     * Se obtiene la diferencia más grande
                     */
                    if (difd2 > difd) {
                        difd = difd2;
                    }

                    /**
                     * Total de meses de diferencia que se utilizarán como
                     * 'sobreabasto'
                     */
                    rset2 = con.consulta("select TIMESTAMPDIFF(month, now(), '2016-02-01' ) as meses;");
                    while (rset2.next()) {
                        meses = rset2.getInt(1);
                    }

                    /**
                     * Variable de la autosuficiencia
                     */
                    Double NIM = 0.0;

                    /**
                     * Se obtiene la existencia de la clave, sumando lo de lote
                     * menos lo que está apartado para que de lo disponible
                     */
                    rset2 = con.consulta("select (F_ExiLot) as F_ExiLot from tb_lote where F_ClaPro = '" + rset.getString("F_ClaPro") + "' and F_ExiLot!=0 union all select -F_Cant from clavefact where F_ClaPro = '" + rset.getString("F_ClaPro") + "' and F_StsFact<5");
                    while (rset2.next()) {
                        totalClave += rset2.getInt(1);
                    }

                    /**
                     * Se obtiene lo surtido por clave
                     */
                    rset2 = con.consulta("select SUM(F_CantSur) as F_CantSur from tb_factura where F_ClaPro = '" + rset.getString("F_ClaPro") + "' and F_StsFact='A'  ");
                    while (rset2.next()) {
                        remisionadoClave = rset2.getDouble("F_CantSur");
                    }
                    /**
                     * Se obtiene un aproximado de lo solicitado por clave
                     */
                    rset2 = con.consulta("select F_ClaPro, (F_PiezasReq) from tb_unireq where F_Status=1 and F_ClaPro = '" + rset.getString("F_ClaPro") + "'   GROUP BY F_FecCarg, F_ClaPro, F_ClaUni ");
                    while (rset2.next()) {
                        solClave = solClave + rset2.getDouble(2);
                    }
                    /**
                     * Si lo solicitado es menos a lo remisionado entonces lo
                     * solicitado será igual a lo entregado. Esto por cambios de
                     * presentación
                     */
                    if (solClave < remisionadoClave) {
                        solClave = remisionadoClave;
                    }
                    /**
                     * Se calcula el ASF con base en lo remisionado
                     */
                    if (remisionadoClave > 0) {
                        /**
                         * Remisionado por clave entre la diferencia de días por
                         * 30 (calculo de consumo promedio mensual)
                         */
                        CPM = (remisionadoClave / difd) * 30;
                        /**
                         * ASF total de existencias entre el consumo promedio
                         * mensual
                         */
                        NIM = (double) totalClave / CPM;
                    }

                    /**
                     * Se calcula el ASF con base en lo remisionado
                     */
                    if (solClave > 0) {
                        CPMSol = (solClave / difd) * 30;
                        NIMSol = (double) totalClave / CPMSol;
                    }

                    String F_FecCom = "", F_FecEnt = "";

                    rset2 = con.consulta("select DATE_FORMAT(MAX(F_FecApl), '%d/%m/%Y') as F_FecCom from tb_compra where F_ClaPro='" + rset.getString("F_ClaPro") + "';");
                    while (rset2.next()) {
                        F_FecCom = rset2.getString(1);
                        if (F_FecCom == null) {
                            F_FecCom = "NA";
                        }
                    }

                    rset2 = con.consulta("select DATE_FORMAT(MAX(F_FecEnt), '%d/%m/%Y') as F_FecEnt from tb_factura where F_ClaPro='" + rset.getString("F_ClaPro") + "';");
                    while (rset2.next()) {
                        F_FecEnt = rset2.getString(1);
                        if (F_FecEnt == null) {
                            F_FecEnt = "NA";
                        }
                    }

                    Calendar c1 = GregorianCalendar.getInstance();
                    c1.add(Calendar.MONTH, -1);
                    Calendar c2 = GregorianCalendar.getInstance();
                    c2.add(Calendar.MONTH, -3);
        %>
        <tr>
            <td><%=TotalClaves%></td>
            <td><%=catalogo%></td>
            <td title="<%=F_DesPro%>"><strong><%=rset.getString("F_ClaPro")%></strong></td>
            <td><%=F_DesPro%></td>
            <td class="text-right"><%=formatter.format(totalClave)%></td>
            <!--
            Mensaje y color dependiendo del NIM 
            -->
            <td class="text-right <%                                if (NIM > meses) {
                    out.println("success");
                } else if (NIM < 1.6 && NIM > 0) {
                    out.println("warning");
                } else if (NIM == 0) {
                    out.println("danger");
                }
                %>"><%=formatter.format(remisionadoClave)%></td>
            <td class="text-right <%                                if (NIM > meses) {
                    out.println("success");
                } else if (NIM < 1.6 && NIM > 0) {
                    out.println("warning");
                } else if (NIM == 0) {
                    out.println("danger");
                }
                %>"><%=formatter.format(CPM)%></td>
            <td class="text-right <%                                if (NIM > meses) {
                    out.println("success");
                } else if (NIM < 1.6 && NIM > 0) {
                    out.println("warning");
                } else if (NIM == 0) {
                    out.println("danger");
                }
                %>"><%=formatter2.format(NIM)%></td>
            <td class="text-right <%                                if (NIMSol > meses) {
                    out.println("success");
                } else if (NIMSol < 1.6 && NIMSol > 0) {
                    out.println("warning");
                } else if (NIMSol == 0) {
                    out.println("danger");
                }
                %>"><%=formatter.format(solClave)%></td>
            <td class="text-right <%                                if (NIMSol > meses) {
                    out.println("success");
                } else if (NIMSol < 1.6 && NIMSol > 0) {
                    out.println("warning");
                } else if (NIMSol == 0) {
                    out.println("danger");
                }
                %>"><%=formatter.format(CPMSol)%></td>
            <td class="text-right <%                                if (NIMSol > meses) {
                    out.println("success");
                } else if (NIMSol < 1.6 && NIMSol > 0) {
                    out.println("warning");
                } else if (NIMSol == 0) {
                    out.println("danger");
                }
                %>"><%=formatter2.format(NIMSol)%></td>
            <td><%=F_FecCom%></td>
            <td><%=F_FecEnt%></td>
            <td>
                <%
                    if (NIM > meses) {
                        if (df3.parse(F_FecCom).after(c1.getTime())) {
                            out.println("Reciente ingreso");
                        } else if (df3.parse(F_FecEnt).before(c2.getTime())) {
                            out.println("Nulo Movimiento");
                        } else {
                            out.println("Sobre abasto");
                        }
                    } else if (NIM < 1.6 && NIM > 0) {
                        out.println("Prox. a agotar");
                    } else if (totalClave == 0) {
                        if (F_FecCom.equals("NA")) {
                            out.println("Nunca Recibida");
                        } else {
                            out.println("Agotada");
                        }
                    } else if (totalClave > 0 && NIM == 0) {
                        out.println("Pendiente por Entregar");
                    } else if (totalClave == 0 && NIM == 0) {
                        out.println("En cero");
                    }
                %>
            </td>
            <td>
                <%
                    if (rset.getString("F_CambioPres").equals("1")) {
                        out.println("Cambio de Presentacion");
                    }
                %>
            </td>
        </tr>
        <%
                    TotalClaves++;
                }
                con.cierraConexion();

            } catch (Exception e) {
                out.println(e.getMessage());
            }
        %>
    </tbody>
</table>