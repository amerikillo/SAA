/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Inventario;

import ISEM.NuevoISEM;
import conn.ConectionDB;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import servlets.Facturacion;

/**
 *
 * @author Americo
 */
public class Devoluciones extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     *
     *
     * Para cambios físicos
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ConectionDB con = new ConectionDB();
        //ConectionDB_SQLServer consql = new ConectionDB_SQLServer();
        Facturacion fact = new Facturacion();
        NuevoISEM objSql = new NuevoISEM();
        java.text.DateFormat df2 = new java.text.SimpleDateFormat("dd/MM/yyyy");
        java.text.DateFormat df3 = new java.text.SimpleDateFormat("yyyy-MM-dd");
        java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession sesion = request.getSession(true);
        try {
            try {

                if (request.getParameter("accion").equals("devolucion")) {
                    con.conectar();
                    //consql.conectar();
                    String ClaPro = "", Total = "", Ubicacion = "", Provee = "", FolLote = "", ClaLot = "", FecCad = "", F_IdLote = "";
                    String F_Cb = "", F_ClaMar = "";
                    String FolLotSql = "";
                    int cantSQL = 0, cant = 0, F_ExiLot = 0;

                    /**
                     * Se obtienen los datos para el cambio físico
                     */
                    ResultSet rset = con.consulta("select * from tb_lote where F_IdLote = '" + request.getParameter("IdLote") + "'");
                    while (rset.next()) {
                        ClaPro = rset.getString("F_ClaPro");
                        cant = rset.getInt("F_ExiLot");
                        ClaLot = rset.getString("F_ClaLot");
                        FecCad = rset.getString("F_FecCad");
                        Ubicacion = rset.getString("F_Ubica");
                        Provee = rset.getString("F_ClaOrg");
                        FolLote = rset.getString("F_FolLot");
                        F_Cb = rset.getString("F_Cb");
                        F_ClaMar = rset.getString("F_ClaMar");
                    }
                    /*ResultSet rsetsql = consql.consulta("select F_FolLot, F_ExiLot from tb_lote where F_ClaLot = '" + ClaLot + "' and F_ClaPro= '" + ClaPro + "' and F_FecCad = '" + df2.format(df3.parse(FecCad)) + "' and F_ClaPrv = '" + Provee + "'");
                     while (rsetsql.next()) {
                     FolLotSql = rsetsql.getString("F_FolLot");
                     cantSQL = rsetsql.getInt("F_ExiLot");
                     }
                     */
                    double importe = devuelveImporte(ClaPro, cant);
                    double iva = devuelveIVA(ClaPro, cant);
                    double costo = devuelveCosto(ClaPro);
                    int ncant = cant;

                    String indMov = objSql.dameidMov();

                    byte[] a = request.getParameter("Obser").getBytes("ISO-8859-1");
                    String Observaciones = (new String(a, "UTF-8")).toUpperCase();

                    /**
                     * Se insertan las observaciones
                     */
                    con.insertar("insert into tb_devolcompra values ('" + request.getParameter("IdLote") + "','" + Observaciones + "','0','" + cant + "','','')");
                    String F_FolLot = "";

                    /**
                     * Se actualiza el cambio, esto ya que se genera el cambio
                     * físico total
                     */
                    con.insertar("update tb_lote set F_ExiLot = '0' where F_IdLote = '" + request.getParameter("IdLote") + "' ");

                    /**
                     * Se obtienen los datos de la ubicación donde se depositará
                     * en caso de que exista el registro
                     */
                    ResultSet rset2 = con.consulta("select F_FolLot, F_IdLote, F_Ubica, F_ExiLot from tb_lote where F_ClaPro = '" + ClaPro + "' and F_ClaLot = '" + request.getParameter("F_ClaLot") + "' and F_FecCad = '" + request.getParameter("F_FecCad") + "' AND F_Ubica in ('NUEVA', 'REJA', 'REDFRIA');");
                    String F_Ubica = "";
                    while (rset2.next()) {
                        F_FolLot = rset2.getString("F_FolLot");
                        F_IdLote = rset2.getString("F_IdLote");
                        F_Ubica = rset2.getString("F_Ubica");
                        F_ExiLot = rset2.getInt("F_ExiLot");
                    }
                    /**
                     * Obtenemos la fecha de fabricación de la nueva caducidad
                     */
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(df3.parse(request.getParameter("F_FecCad")));
                    cal.add(Calendar.YEAR, -3);
                    String Fecfab = "" + df3.format(cal.getTime());
                    if (F_FolLot.equals("")) {
                        F_Ubica = "NUEVA";
                        /**
                         * En caso de que no exista el registro se inserta uno
                         * nuevo en nueva
                         */
                        F_FolLot = devuelveIndLote() + "";
                        con.insertar("insert into tb_lote values (0,'" + ClaPro + "','" + request.getParameter("F_ClaLot") + "','" + request.getParameter("F_FecCad") + "','" + cant + "','" + F_FolLot + "','" + Provee + "','NUEVA','" + Fecfab + "','" + F_Cb + "','" + F_ClaMar + "') ");
                    } else {
                        /**
                         * Si existe se actualiza la cantidad que se tenía
                         * anteriormente más lo que se agregará
                         */
                        con.insertar("update tb_lote set F_ExiLot = '" + (cant + F_ExiLot) + "' where F_IdLote = '" + F_IdLote + "' ");
                    }

                    /**
                     * Inserción de movimientos de entrada y salida
                     */
                    con.insertar("insert into tb_movinv values('0',CURDATE(),'0','53','" + ClaPro + "','" + cant + "','" + costo + "','" + importe + "','-1','" + FolLote + "','" + Ubicacion + "','" + Provee + "',CURTIME(),'" + (String) sesion.getAttribute("nombre") + "')");
                    con.insertar("insert into tb_movinv values('0',CURDATE(),'0','4','" + ClaPro + "','" + cant + "','" + costo + "','" + importe + "','1','" + F_FolLot + "','" + F_Ubica + "','" + Provee + "',CURTIME(),'" + (String) sesion.getAttribute("nombre") + "')");

                    //consql.insertar("insert into TB_MovInv values(CONVERT(date,GETDATE()),'1','','52','" + ClaPro + "','" + cant + "','" + costo + "','" + iva + "','" + importe + "','-1','" + FolLotSql + "','" + indMov + "','A','0','','','','" + Provee + "','" + (String) sesion.getAttribute("nombre") + "')");
                    //consql.insertar("update TB_Lote set F_ExiLot='" + ncant + "' where F_FolLot = '" + FolLotSql + "'");
                    //consql.cierraConexion();
                    con.cierraConexion();
                    out.println("<script>alert('Cambio físico correcto')</script>");
                    out.println("<script>window.location='devolucionesInsumo.jsp'</script>");
                }
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        } finally {
            out.close();
        }
    }

    /**
     * Metodo para que nos devuelva el importe de una clave
     *
     * @param clave
     * @param cantidad
     * @return
     * @throws SQLException
     */
    public double devuelveImporte(String clave, int cantidad) throws SQLException {

        ConectionDB con = new ConectionDB();
        int Tipo = 0;
        double Costo = 0.0, IVA = 0.0, Monto = 0.0, IVAPro = 0.0, MontoIva = 0.0;
        con.conectar();
        ResultSet rset = con.consulta("select F_TipMed, F_Costo from tb_medica where F_ClaPro = '" + clave + "'");
        while (rset.next()) {
            Tipo = rset.getInt(1);
            Costo = rset.getDouble(2);
        }
        if (Tipo == 2504) {
            IVA = 0.0;
        } else {
            IVA = 0.16;
        }
        IVAPro = (cantidad * Costo) * IVA;
        Monto = cantidad * Costo;
        MontoIva = Monto + IVAPro;
        con.cierraConexion();
        return MontoIva;
    }

    /**
     * Metodo para obtener el iva de una clave y su cantidad
     *
     * @param clave
     * @param cantidad
     * @return
     * @throws SQLException
     */
    public double devuelveIVA(String clave, int cantidad) throws SQLException {

        ConectionDB con = new ConectionDB();
        int Tipo = 0;
        double Costo = 0.0, IVA = 0.0, IVAPro = 0.0;
        con.conectar();
        ResultSet rset = con.consulta("select F_TipMed, F_Costo from tb_medica where F_ClaPro = '" + clave + "'");
        while (rset.next()) {
            Tipo = rset.getInt(1);
            Costo = rset.getDouble(2);
        }
        if (Tipo == 2504) {
            IVA = 0.0;
        } else {
            IVA = 0.16;
        }
        IVAPro = (cantidad * Costo) * IVA;
        con.cierraConexion();
        return IVAPro;
    }

    /**
     * Metodo para obtener el costo de un insumo
     *
     * @param Clave
     * @return
     * @throws SQLException
     */
    public double devuelveCosto(String Clave) throws SQLException {
        ConectionDB con = new ConectionDB();
        double Costo = 0.0;
        con.conectar();
        ResultSet rset = con.consulta("select F_Costo from tb_medica where F_ClaPro = '" + Clave + "'");
        while (rset.next()) {
            Costo = rset.getDouble(1);
        }
        return Costo;

    }

    /**
     * Metodo para obtener el indice del nuevo lote
     *
     * @return
     * @throws SQLException
     */
    public int devuelveIndLote() throws SQLException {
        ConectionDB con = new ConectionDB();
        int indice = 0;
        con.conectar();
        ResultSet rset_Ind = con.consulta("SELECT F_IndLote FROM tb_indice");
        while (rset_Ind.next()) {
            indice = rset_Ind.getInt("F_IndLote");
            int FolioLot = indice + 1;
            con.actualizar("update tb_indice set F_IndLote='" + FolioLot + "'");
        }
        con.cierraConexion();
        return indice;
    }
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
