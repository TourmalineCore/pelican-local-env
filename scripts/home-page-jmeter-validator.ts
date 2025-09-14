import { 
  readJmeterResultFile,
  parseJmeterResults,
  getMetrics,
  calculateTotalDataSize,
  printJmeterReport,
  printJmeterIssues
} from "../utils";

(async () => {
  const data = readJmeterResultFile('./result/home-page.jtl');

  try {
    const samples = await parseJmeterResults(data);

    const {
      errorCount,
      avg,
      min,
      max,
      p95,
      p99
    } = getMetrics(samples);

    const { 
      totalBytes,
      totalKB,
      totalMB
    } = calculateTotalDataSize(samples);
    
    printJmeterReport({
      pageName: 'Home Page',
      errorCount,
      avg,
      min,
      max,
      p95,
      p99,
      totalBytes,
      totalKB,
      totalMB
    });
  } catch (err: any) {
    console.error(`Error while parsing results: ${err.message}`);
  }
})();
