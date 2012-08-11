
#import "curl.h"
#import <UIKit/UIKit.h>

#define MY_USR_AGENT "CURL-AGENT 1.0"

typedef struct _DATA
{
	NSMutableString *pstr;
	bool bGrab;
} DATA;


static size_t writefunction( void *ptr , size_t size , size_t nmemb , void *stream )
{
	if ( !((DATA*) stream)->bGrab )
		return -1;
	
	NSMutableString* pStr = ((DATA*) stream)->pstr;

	if ( size * nmemb )
		[pStr appendString:[NSString stringWithCString: (char*)ptr length:size*nmemb]];

	return nmemb * size;
}

static bool DownloadURLContent(NSString * strUrl, NSMutableString*  strContent, NSMutableString* headers, NSMutableString* cookies, bool grabHeaders, bool grabUrl)
{
	CURL *curl_handle;
	DATA data =	{ strContent, grabUrl };
	DATA headers_data = {headers , grabHeaders};
    DATA headers_cookies = {cookies , true};


	if ( curl_global_init(CURL_GLOBAL_ALL) != CURLE_OK )
		return false;

	if ( (curl_handle = curl_easy_init()) == NULL )
		return false;

#if 0
	//just if you want to debug
	if( curl_easy_setopt(curl_handle, CURLOPT_VERBOSE, 1)!= CURLE_OK)
		goto clean_up;

	if( curl_easy_setopt(curl_handle, CURLOPT_STDERR, stdout) != CURLE_OK)
		goto clean_up;
#endif

	char stdError[CURL_ERROR_SIZE] = { '\0' };
	if ( curl_easy_setopt(curl_handle, CURLOPT_ERRORBUFFER , stdError) != CURLE_OK )
		goto clean_up;

	if ( curl_easy_setopt(curl_handle, CURLOPT_URL, [strUrl UTF8String]) != CURLE_OK )
		goto clean_up;

	if ( curl_easy_setopt(curl_handle, CURLOPT_WRITEFUNCTION, writefunction) != CURLE_OK )
		goto clean_up;

	if(grabHeaders)
	{
		if ( curl_easy_setopt(curl_handle, CURLOPT_HEADERFUNCTION, writefunction) != CURLE_OK )
			goto clean_up;

		if ( curl_easy_setopt(curl_handle, CURLOPT_WRITEHEADER, (void *)&headers_data) != CURLE_OK )
			goto clean_up;
	}

    if ( curl_easy_setopt(curl_handle, CURLOPT_HEADERFUNCTION, writefunction) != CURLE_OK )
        goto clean_up;


	if ( curl_easy_setopt(curl_handle, CURLOPT_WRITEDATA, (void *)&data) != CURLE_OK )
		goto clean_up;

	if ( curl_easy_setopt(curl_handle, CURLOPT_USERAGENT, MY_USR_AGENT) != CURLE_OK )
		goto clean_up;

	if ( curl_easy_perform(curl_handle) != CURLE_OK )
		if ( grabUrl )
			goto clean_up;
	
	curl_easy_cleanup(curl_handle);
	curl_global_cleanup();
	return true;

clean_up:
	printf("(%s %d) error: %s", __FILE__,__LINE__, stdError);
	curl_easy_cleanup(curl_handle);
	curl_global_cleanup();
	return false;
}

