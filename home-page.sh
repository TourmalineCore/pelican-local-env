#Cleanup
rm ./report/home-page/home-page.jtl
rm ./result/home-page.jtl
rm ./jmeter-test.txt

apache-jmeter-5.6.3/bin/jmeter.sh -n -t ./tests/jmeter-tests/home-page-5.jmx \
	-l ./report/home-page/home-page.jtl \
	-Jjmeter.save.saveservice.output_format=xml \
	-Jjmeter.save.saveservice.print_field_names=true \
	-Jjmeter.save.saveservice.response_data.on_error=true \
	-Jjmeter.save.saveservice.bytes=true \
	-Jjmeter.save.saveservice.timestamp_format=ms;
cp ./report/home-page/home-page.jtl ./result/home-page.jtl || true

echo ===========5-1============ >> jmeter-test.txt
npx tsx scripts/home-page-jmeter-validator.ts >> jmeter-test.txt

#Cleanup
rm ./report/home-page/home-page.jtl
rm ./result/home-page.jtl

apache-jmeter-5.6.3/bin/jmeter.sh -n -t ./tests/jmeter-tests/home-page-5.jmx \
	-l ./report/home-page/home-page.jtl \
	-Jjmeter.save.saveservice.output_format=xml \
	-Jjmeter.save.saveservice.print_field_names=true \
	-Jjmeter.save.saveservice.response_data.on_error=true \
	-Jjmeter.save.saveservice.bytes=true \
	-Jjmeter.save.saveservice.timestamp_format=ms;
cp ./report/home-page/home-page.jtl ./result/home-page.jtl || true

echo ===========5-2============ >> jmeter-test.txt
npx tsx scripts/home-page-jmeter-validator.ts >> jmeter-test.txt

#Cleanup
rm ./report/home-page/home-page.jtl
rm ./result/home-page.jtl

apache-jmeter-5.6.3/bin/jmeter.sh -n -t ./tests/jmeter-tests/home-page-10.jmx \
	-l ./report/home-page/home-page.jtl \
	-Jjmeter.save.saveservice.output_format=xml \
	-Jjmeter.save.saveservice.print_field_names=true \
	-Jjmeter.save.saveservice.response_data.on_error=true \
	-Jjmeter.save.saveservice.bytes=true \
	-Jjmeter.save.saveservice.timestamp_format=ms;

cp ./report/home-page/home-page.jtl ./result/home-page.jtl || true

echo ===========10-1============ >> jmeter-test.txt
npx tsx scripts/home-page-jmeter-validator.ts >> jmeter-test.txt

#Cleanup
rm ./report/home-page/home-page.jtl
rm ./result/home-page.jtl

apache-jmeter-5.6.3/bin/jmeter.sh -n -t ./tests/jmeter-tests/home-page-10.jmx \
	-l ./report/home-page/home-page.jtl \
	-Jjmeter.save.saveservice.output_format=xml \
	-Jjmeter.save.saveservice.print_field_names=true \
	-Jjmeter.save.saveservice.response_data.on_error=true \
	-Jjmeter.save.saveservice.bytes=true \
	-Jjmeter.save.saveservice.timestamp_format=ms;

cp ./report/home-page/home-page.jtl ./result/home-page.jtl || true

echo ===========10-2============ >> jmeter-test.txt
npx tsx scripts/home-page-jmeter-validator.ts >> jmeter-test.txt

#Cleanup
rm ./report/home-page/home-page.jtl
rm ./result/home-page.jtl

apache-jmeter-5.6.3/bin/jmeter.sh -n -t ./tests/jmeter-tests/home-page-30.jmx \
	-l ./report/home-page/home-page.jtl \
	-Jjmeter.save.saveservice.output_format=xml \
	-Jjmeter.save.saveservice.print_field_names=true \
	-Jjmeter.save.saveservice.response_data.on_error=true \
	-Jjmeter.save.saveservice.bytes=true \
	-Jjmeter.save.saveservice.timestamp_format=ms;

cp ./report/home-page/home-page.jtl ./result/home-page.jtl || true

echo ===========30-1============ >> jmeter-test.txt
npx tsx scripts/home-page-jmeter-validator.ts >> jmeter-test.txt

#Cleanup
rm ./report/home-page/home-page.jtl
rm ./result/home-page.jtl

apache-jmeter-5.6.3/bin/jmeter.sh -n -t ./tests/jmeter-tests/home-page-30.jmx \
	-l ./report/home-page/home-page.jtl \
	-Jjmeter.save.saveservice.output_format=xml \
	-Jjmeter.save.saveservice.print_field_names=true \
	-Jjmeter.save.saveservice.response_data.on_error=true \
	-Jjmeter.save.saveservice.bytes=true \
	-Jjmeter.save.saveservice.timestamp_format=ms;

cp ./report/home-page/home-page.jtl ./result/home-page.jtl || true

echo ===========30-2============ >> jmeter-test.txt
npx tsx scripts/home-page-jmeter-validator.ts >> jmeter-test.txt

#Cleanup
rm ./report/home-page/home-page.jtl
rm ./result/home-page.jtl

apache-jmeter-5.6.3/bin/jmeter.sh -n -t ./tests/jmeter-tests/home-page-50.jmx \
	-l ./report/home-page/home-page.jtl \
	-Jjmeter.save.saveservice.output_format=xml \
	-Jjmeter.save.saveservice.print_field_names=true \
	-Jjmeter.save.saveservice.response_data.on_error=true \
	-Jjmeter.save.saveservice.bytes=true \
	-Jjmeter.save.saveservice.timestamp_format=ms;

cp ./report/home-page/home-page.jtl ./result/home-page.jtl || true

echo ===========50-1============ >> jmeter-test.txt
npx tsx scripts/home-page-jmeter-validator.ts >> jmeter-test.txt

#Cleanup
rm ./report/home-page/home-page.jtl
rm ./result/home-page.jtl

apache-jmeter-5.6.3/bin/jmeter.sh -n -t ./tests/jmeter-tests/home-page-50.jmx \
	-l ./report/home-page/home-page.jtl \
	-Jjmeter.save.saveservice.output_format=xml \
	-Jjmeter.save.saveservice.print_field_names=true \
	-Jjmeter.save.saveservice.response_data.on_error=true \
	-Jjmeter.save.saveservice.bytes=true \
	-Jjmeter.save.saveservice.timestamp_format=ms;

cp ./report/home-page/home-page.jtl ./result/home-page.jtl || true

echo ===========50-2============ >> jmeter-test.txt
npx tsx scripts/home-page-jmeter-validator.ts >> jmeter-test.txt

#Cleanup
rm ./report/home-page/home-page.jtl
rm ./result/home-page.jtl