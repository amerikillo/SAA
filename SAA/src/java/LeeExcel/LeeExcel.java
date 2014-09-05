package LeeExcel;

import conn.ConectionDB;
import java.io.FileInputStream;
import java.sql.ResultSet;
import java.util.Iterator;
import java.util.Vector;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 *
 * @author Indra Hidayatulloh
 */
public class LeeExcel {

    private Vector vectorDataExcelXLSX = new Vector();
    ConectionDB con = new ConectionDB();

    public boolean obtieneArchivo(String path, String file) {
        String excelXLSXFileName = path + "/exceles/" + file;
        vectorDataExcelXLSX = readDataExcelXLSX(excelXLSXFileName);
        displayDataExcelXLSX(vectorDataExcelXLSX);
        return true;
    }

    public Vector readDataExcelXLSX(String fileName) {
        Vector vectorData = new Vector();

        try {
            FileInputStream fileInputStream = new FileInputStream(fileName);

            XSSFWorkbook xssfWorkBook = new XSSFWorkbook(fileInputStream);

            // Read data at sheet 0
            XSSFSheet xssfSheet = xssfWorkBook.getSheetAt(0);

            Iterator rowIteration = xssfSheet.rowIterator();

            // Looping every row at sheet 0
            while (rowIteration.hasNext()) {
                XSSFRow xssfRow = (XSSFRow) rowIteration.next();
                Iterator cellIteration = xssfRow.cellIterator();

                Vector vectorCellEachRowData = new Vector();

                // Looping every cell in each row at sheet 0
                while (cellIteration.hasNext()) {
                    XSSFCell xssfCell = (XSSFCell) cellIteration.next();
                    vectorCellEachRowData.addElement(xssfCell);
                }

                vectorData.addElement(vectorCellEachRowData);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return vectorData;
    }

    public void displayDataExcelXLSX(Vector vectorData) {
        // Looping every row data in vector

        for (int i = 0; i < vectorData.size(); i++) {
            Vector vectorCellEachRowData = (Vector) vectorData.get(i);
            String qry = "insert into tb_unireq values (";
            // looping every cell in each row
            for (int j = 0; j < 4; j++) {

                if (j == 0) {
                    try {
                        String Clave = agrega((int) Double.parseDouble(vectorCellEachRowData.get(j).toString()) + "");
                        qry = qry + "'" + Clave + "' , ";
                    } catch (Exception e) {
                    }
                } else if (j == 1) {
                    System.out.println("algo");
                    try {
                        String ClaPro = ((vectorCellEachRowData.get(j).toString()) + "");
                        System.out.println(ClaPro);
                        String[] punto = ClaPro.split("\\.");
                        System.out.println(punto.length);
                        if (punto.length > 1) {
                            System.out.println(ClaPro + "***" + punto[0] + "////" + punto[1]);
                            if (punto[1].equals("01")) {
                                ClaPro = agrega(punto[0]) + ".01";
                            } else {
                                ClaPro = agrega(punto[0]);
                            }
                            System.out.println(ClaPro);
                        }
                        String tipMed = "";
                        con.conectar();
                        ResultSet rset2 = con.consulta("select F_TipMed from tb_medica where F_ClaPro='" + ClaPro + "'");
                        while (rset2.next()) {
                            tipMed = rset2.getString(1);
                        }
                        con.cierraConexion();
                        if (tipMed.equals("2504")) {
                            String[] dec = ClaPro.split("\\.");
                            System.out.println(dec.length);
                            System.out.println(ClaPro + "***" + dec[0] + "////" + dec[1]);
                            if (dec[1].equals("01")) {
                                qry = qry + "'" + agrega(dec[0]) + ".01" + "' , ";
                            } else {
                                qry = qry + "'" + agrega(ClaPro) + "' , ";
                            }
                        } else {
                            qry = qry + "'" + agrega(ClaPro) + "' , ";
                        }

                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                } else {
                    try {
                        String Clave = ((int) Double.parseDouble(vectorCellEachRowData.get(j).toString()) + "");
                        qry = qry + "'" + Clave + "' , ";
                    } catch (Exception e) {
                    }
                }
            }
            qry = qry + "curdate(), 0, '0')"; // agregar campos fuera del excel
            try {
                con.conectar();
                try {
                    con.insertar(qry);
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
                con.cierraConexion();
            } catch (Exception e) {
            }
        }
    }

    public String agrega(String clave) {
        String clave2 = "";
        if (clave.length() < 4) {

            if (!clave.substring(0, 1).equals("0")) {
                //System.out.println(clave);
                if (clave.length() == 1) {
                    clave2 = ("000" + clave);
                }
                if (clave.length() == 2) {
                    clave2 = ("00" + clave);
                }
                if (clave.length() >= 3) {
                    clave2 = ("0" + clave);
                }

            }
        } else {
            clave2 = clave;
        }
        return clave2;
    }

}
