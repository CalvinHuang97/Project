import pandas as pd

def main():
    df = pd.read_csv('./../data/ride_length.csv',header = None, names = ['ride_length', 'member_type'])
    df['ride_length'] = pd.to_timedelta(df['ride_length'],unit='h',errors='coerce')
    df.dropna(inplace=True)
    result = df.groupby("member_type").mean(numeric_only=False)

    breakpoint()



if __name__ == '__main__':
    main()
