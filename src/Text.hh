
#ifndef TEXT_HH
#define TEXT_HH

/*
* Text.hh
*
*  Created on: Jun 29, 2017
*      Author: nicolas
*/

#ifndef TEXT_HH_
#define TEXT_HH_

#include "Serializer.hh"
#include "Event.hh"
#include <string>
#include <stdlib.h>
#include <unistd.h>

class Text: public Serializer {

private:
std::string format;

// separators
char separator;
char paramSeparator;
char keyValueSeparator;

std::vector<std::string> fields;
unsigned int fieldNumber;
const std::vector<std::string> split(const std::string data,
const char separator) const;

protected:
const std::string getField(const std::string field,
const Event& event) const;
void setField(const std::string field, const std::string value,
Event& event) const;

public:
Text();
virtual ~Text();
virtual void configure(std::map<std::string, std::string> configList);
virtual const std::string serialize(const Event event) const;
const std::string serializeParams(const Event event) const;
virtual Event parse(const std::string data) const;
void parseParameters(Event& event, const std::string data) const;
void setFormat(const std::string format);
const std::string getFormat() const;
void setSeparator(const char separator);
void setParamSeparator(const char paramSeparator);
void setKeyValueSeparator(const char keyValueSeparator);
};

#endif /* TEXT_HH_ */


#endif

