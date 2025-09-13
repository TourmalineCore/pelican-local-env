
if ! apache-jmeter-5.6.3/bin/jmeter.sh -n -t ./tests/jmeter-tests/home-page.jmx \
	-l ./report/home-page/home-page.jtl \
	-Jjmeter.save.saveservice.output_format=xml \
	-Jjmeter.save.saveservice.print_field_names=true \
	-Jjmeter.save.saveservice.response_data.on_error=true \
	-Jjmeter.save.saveservice.bytes=true \
	-Jjmeter.save.saveservice.timestamp_format=ms; then
	JMETER_FAIL_homePage=1 
	echo "❌ JMeter test execution failed: Home Page" >> ./errors/summary.txt
fi
cp ./report/home-page/home-page.jtl ./result/home-page.jtl || true


npx tsx scripts/home-page-jmeter-validator.ts
