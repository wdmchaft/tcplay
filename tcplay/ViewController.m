//
//  ViewController.m
//  tcplay
//
//  Created by Tiago Barufi on 12/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import "Classes/SBJson.h"
#import "Musica.h"
#import "MusicaViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize show;
@synthesize tw;
@synthesize generos;
NSMutableData *responseData;
NSURL *videoURL;
NSString *genero;
- (void)viewDidLoad
{
    self.generos=[[NSArray alloc] init];
    
    [super viewDidLoad];
    show.text=@"peganingas";
    [show setText:@"Hello, World!"];
    
	// Do any additional setup after loading the view, typically from a nib.
    NSString *jsonString = [NSString stringWithString:@"{\"foo\": \"bar\"}"];
	NSDictionary *dictionary = [jsonString JSONValue];
	NSLog(@"Dictionary value for \"foo\" is \"%@\"", [dictionary objectForKey:@"foo"]);
    [self pull];
}


- (void)pull{
    responseData = [NSMutableData data];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.0.105/works/tcplay/backend/juke.php"]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"Generos";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }

    NSUInteger row = [indexPath row];
    [((UIButton *)[cell viewWithTag:1]) setTitle:[self.generos objectAtIndex:row] forState:UIControlStateNormal];

    return cell;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return YES;
//}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	show.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	NSArray *trax = [responseString JSONValue];
    NSMutableArray *genus=[[NSMutableArray alloc] init ];
	NSMutableString *text = [NSMutableString stringWithString:@"Lucky numbers:\n"];
    NSMutableArray *ro = [[NSMutableArray alloc] init ];
    for (int i = 0; i < [trax count]; i++){
		[text appendFormat:@"%@\n", [trax objectAtIndex:i]];
        Musica *s=[[Musica alloc]init];
        s.titulo=[[trax objectAtIndex:i] objectForKey: @"title"];
        s.performer=[[trax objectAtIndex:i] objectForKey: @"artist"];
        s.id=(int)[[trax objectAtIndex:i] objectForKey: @"id"];
        s.genero=[[trax objectAtIndex:i] objectForKey: @"genero"];
        [ro addObject: s];
        if (![genus containsObject: s.genero]){
            [genus addObject: s.genero];
        }
    }
    self.generos = genus;
    rows = [ro sortedArrayUsingComparator:^(id a, id b) {
        NSString *first = [(Musica*)a performer];
        NSString *second = [(Musica*)b performer];
        return [first compare:second];
    }];
	show.text =  text;
    [self.tw reloadData];
}

- (IBAction) pinga{
    show.text=@"Hello, World!";
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.generos count];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"vaivai"]) {
        NSMutableArray *mu = [[NSMutableArray alloc]init];
        for (int i = 0; i < [rows count]; i++){
            
            NSLog([[rows objectAtIndex:i] genero]);
            if([[[rows objectAtIndex:i] genero] isEqualToString: genero]){
                [mu addObject:[rows objectAtIndex:i]];
            }
        }
        MusicaViewController *ibcVC = [segue destinationViewController];
        ibcVC.songs = mu;
    }
}

- (IBAction) walk:(id)sender {
    NSLog(@"Button pressed: %@", [sender currentTitle]);
    genero=[sender currentTitle];
    show.text=@"Hello, World!";
    [self performSegueWithIdentifier: @"vaivai" sender: self];
}

@end
