using Test

function packet_processor(input)
    bits = length(input) * 4
    packet = parse(BigInt, input; base = 16)
    versions = []

    function get_next_bits(n)
        v = packet >> (bits - n)
        mask = (big(1) << (bits - n)) - 1
        packet &= mask
        bits -= n
        return v
    end

    function process_packet()
        version = get_next_bits(3)
        push!(versions, version)
        type = get_next_bits(3)
        processed = 6

        if type == 4
            last = get_next_bits(1)
            value = get_next_bits(4)
            processed += 5
            while last == 1
                last, v = get_next_bits(1), get_next_bits(4)
                value = (value << 4 | v)
                processed += 5
            end
            return value, processed
        end

        value::Int128 = type == 1 ? 1 : type == 2 ? (Int128(1) << 127) - 1 : type == 3 ? (Int128(1) << 127) : 0
        length_type = get_next_bits(1)
        size = length_type == 0 ? 15 : 11
        length = get_next_bits(size)
        processed += 1 + size

        if type <= 3
            i = 0
            while i < length
                v, p = process_packet()
                processed += p
                value = if type == 0
                    value + v
                elseif type == 1
                    value * v
                elseif type == 2
                    min(value, v)
                elseif type == 3
                    max(value, v)
                end

                i = length_type == 0 ? i + p : i + 1
            end
        else
            v1, p = process_packet()
            processed += p
            v2, p = process_packet()
            processed += p
            value = if type == 5
                v1 > v2 ? 1 : 0
            elseif type == 6
                v1 < v2 ? 1 : 0
            elseif type == 7
                v1 == v2 ? 1 : 0
            end
        end

        return value, processed
    end

    v, _ = process_packet()

    return versions, v
end

function part_one(input)
    v, _ = packet_processor(input)
    return reduce(+, v)
end

function part_two(input)
    _, v = packet_processor(input)
    return v
end

function test()
    example = """8A004A801A8002F478"""
    example2 = """620080001611562C8802118E34"""
    example3 = """C0015000016115A2E0802F182340"""
    example4 = """A0016C880162017C3686B18A3D4780"""

    example5 = """C200B40A82"""
    example6 = """04005AC33890"""
    example7 = """880086C3E88112"""
    example8 = """CE00C43D881120"""
    example9 = """D8005AC2A8F0"""
    example10 = """F600BC2D8F"""
    example11 = """9C005AC2F8F0"""
    example12 = """9C0141080250320F1802104A08"""

    @test part_one(example) == 16
    @test part_one(example2) == 12
    @test part_one(example3) == 23
    @test part_one(example4) == 31

    @test part_two(example5) == 3
    @test part_two(example6) == 54
    @test part_two(example7) == 7
    @test part_two(example8) == 9
    @test part_two(example9) == 1
    @test part_two(example10) == 0
    @test part_two(example11) == 0
    @test part_two(example12) == 1
end
